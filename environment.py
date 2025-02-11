# environment.py

import os

from config_helper import config, logger


def get_api_var() -> str:
    if not os.getenv("CLEAR_SKY"):
        api_environment = config.get("environment", "api")
        if not api_environment:
            logger.warning("Using default environment.")
            api_environment = "prod"
    else:
        if os.getenv("CLEAR_SKY") and config.get("environment", "api"):
            logger.warning("environment override.")
            api_environment = config.get("environment", "api")
        else:
            api_environment = os.environ.get("CLEARSKY_ENVIRONMENT")
            if not api_environment:
                logger.warning("Using default environment.")
                api_environment = "prod"

    return api_environment
