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


async def create_db():
    try:
        async with database_handler.connection_pool.acquire() as connection:
            async with connection.transaction():
                create_users_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    did text primary key,
                    handle text,
                    status bool
                )
                """.format(users_table)

                create_blocklists_table = """
                CREATE TABLE IF NOT EXISTS {} (
                    user_did text,
                    blocked_did text,
                    block_date text
                )
                """.format(blocklist_table)

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

                await connection.execute(create_users_table)
                await connection.execute(create_blocklists_table)
                await connection.execute(create_top_blocks_table)
                await connection.execute(create_top_24_blocks_table)

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

    await database_handler.create_connection_pool()

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
