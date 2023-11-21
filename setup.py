# setup.py

import sys
from config_helper import logger
import asyncio
import database_handler
import test
import argparse
import app

users_table = "users"
blocklist_table = "blocklists"
top_blocks_table = "top_block"
top_24_blocks_table = "top_twentyfour_hour_block"
mute_lists_table = "mutelists"
mute_lists_users_table = "mutelists_users"
user_prefixes_table = "user_prefixes"
last_created_table = "last_did_created_date"
blocklist_transaction_table = "blocklists_transaction"
mute_lists_transaction_table = "mutelists_transaction"
mute_lists_users_transaction_table = "mutelists_users_transaction"
subscribe_block_list_table = "subscribe_blocklists"
subscribe_block_list_transaction_table = "subscribe_blocklists_transaction"
pds_table = "pds"


async def create_db():
    try:
        async with database_handler.connection_pools["write"].acquire() as connection:
            async with connection.transaction():
                create_users_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    did text primary key,
                    handle text,
                    status bool,
                    pds text,
                    created_date text
                )
                """.format(users_table)

                create_blocklists_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    user_did text,
                    blocked_did text,
                    block_date timestamptz,
                    cid text,
                    uri text primary key,
                    touched timestamptz,
                    touched_actor text
                )
                """.format(blocklist_table)

                create_blocklists_transaction_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    serial_id BIGSERIAL primary key,
                    user_did text,
                    blocked_did text,
                    block_date timestamptz,
                    cid text,
                    uri text not null,
                    touched timestamptz,
                    touched_actor text
                )
                """.format(blocklist_transaction_table)

                create_top_blocks_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    did text,
                    count int,
                    list_type text
                )
                """.format(top_blocks_table)

                create_top_24_blocks_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    did text,
                    count int,
                    list_type text
                )
                """.format(top_24_blocks_table)

                create_mute_lists_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    url text,
                    uri text primary key,
                    did text,
                    cid text,
                    name text,
                    created_date timestamptz,
                    description text,
                    touched timestamptz,
                    touched_actor text
                )
                """.format(mute_lists_table)

                create_mute_lists_transaction_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    serial_id BIGSERIAL primary key,
                    url text,
                    uri text not null,
                    did text,
                    cid text,
                    name text,
                    created_date timestamptz,
                    description text,
                    touched timestamptz,
                    touched_actor text
                )
                """.format(mute_lists_transaction_table)

                create_mute_list_users_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    list_uri text,
                    listitem_uri text,
                    cid text,
                    subject_did text,
                    owner_did text,
                    date_added timestamptz,
                    touched timestamptz,
                    touched_actor text,
                    PRIMARY KEY (listitem_uri, subject_did)
                )
                """.format(mute_lists_users_table)

                create_mute_list_users_transaction_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    serial_id BIGSERIAL primary key,
                    list_uri text,
                    listitem_uri text not null,
                    cid text,
                    did text,
                    date_added timestamptz,
                    touched timestamptz,
                    touched_actor text,
                )
                """.format(mute_lists_users_transaction_table)

                create_subscribe_block_list_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    did text,
                    uri text primary key,
                    list_uri text,
                    cid text,
                    date_added timestamptz,
                    touched timestamptz,
                    touched_actor text,
                )
                """.format(subscribe_block_list_table)

                create_subscribe_block_list_transaction_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    serial_id BIGSERIAL primary key,
                    did text,
                    uri text,
                    list_uri text,
                    cid text,
                    date_added timestamptz,
                    touched timestamptz,
                    touched_actor text,
                )
                """.format(subscribe_block_list_transaction_table)

                create_user_prefixes = """CREATE TABLE IF NOT EXISTS {} (
                handle TEXT PRIMARY KEY,
                prefix1 TEXT NOT NULL,
                prefix2 TEXT NOT NULL,
                prefix3 TEXT NOT NULL
                )""".format(user_prefixes_table)

                create_pds_table = """CREATE TABLE IF NOT EXISTS {} (
                pds TEXT PRIMARY KEY,
                status BOOL""".format(pds_table)

                create_last_created_table = """CREATE TABLE IF NOT EXISTS {} (
                last_created timestamptz PRIMARY KEY""".format(last_created_table)

                index_1 = """CREATE INDEX IF NOT EXISTS blocklist_user_did ON blocklists (user_did)"""
                index_2 = """CREATE INDEX IF NOT EXISTS blocklist_blocked_did ON blocklists (blocked_did)"""
                index_3 = """CREATE INDEX idx_user_prefixes_prefix1 ON user_prefixes(prefix1)"""
                index_4 = """CREATE INDEX idx_user_prefixes_prefix2 ON user_prefixes(prefix2)"""
                index_5 = """CREATE INDEX idx_user_prefixes_prefix3 ON user_prefixes(prefix3)"""

                await connection.execute(create_users_table)
                await connection.execute(create_blocklists_table)
                await connection.execute(create_top_blocks_table)
                await connection.execute(create_top_24_blocks_table)
                await connection.execute(create_mute_lists_table)
                await connection.execute(create_mute_list_users_table)
                await connection.execute(create_user_prefixes)
                await connection.execute(create_last_created_table)
                await connection.execute(create_blocklists_transaction_table)
                await connection.execute(create_mute_lists_transaction_table)
                await connection.execute(create_mute_list_users_transaction_table)
                await connection.execute(create_subscribe_block_list_table)
                await connection.execute(create_subscribe_block_list_transaction_table)
                await connection.execute(create_pds_table)

                await connection.execute(index_1)
                await connection.execute(index_2)
                await connection.execute(index_3)
                await connection.execute(index_4)
                await connection.execute(index_5)

                logger.info("tables created")
    except Exception as e:
        logger.error(f"Error creating db: {e}")


# ======================================================================================================================
# =============================================== Main Logic ===========================================================
async def main():
    # python setup.py --generate-test-data // generate test data
    # python setup.py --create-db // create db tables
    # python setup.py --start-test // create data and start application

    parser = argparse.ArgumentParser(description='ClearSky Update Manager: ' + app.version)
    parser.add_argument('--generate-test-data', action='store_true', help='generate test data')
    parser.add_argument('--create-db', action='store_true', help='create db tables')
    parser.add_argument('--start-test', action='store_true', help='create data and start application')
    args = parser.parse_args()

    await database_handler.create_connection_pool("local")

    if args.generate_test_data:
        user_data_list = await test.generate_random_user_data()
        await test.generate_random_block_data(user_data_list)
        sys.exit()
    elif args.create_db:
        logger.info("creating db tables.")

        await create_db()

        sys.exit()
    elif args.start_test:
        logger.info("creating db tables.")
        await create_db()

        logger.info("Creating test data.")
        user_data_list = await test.generate_random_user_data()
        logger.info("This will take a couple of minutes...please wait.")
        await test.generate_random_block_data(user_data_list)
        await database_handler.close_connection_pool()

        logger.info("Starting Application.")
        await app.main()
    else:
        sys.exit()

if __name__ == '__main__':
    asyncio.run(main())
