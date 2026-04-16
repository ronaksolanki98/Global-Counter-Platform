import json
import os
import logging
from decimal import Decimal
from typing import Dict

import boto3
from botocore.exceptions import ClientError

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

TABLE_NAME = os.getenv('TABLE_NAME', 'serverless_web_application_views')
TRACKING_ID = os.getenv('TRACKING_ID', 'GLOBAL_COUNTER')
PARTITION_KEY = 'id'

_dynamodb = boto3.resource('dynamodb')
_table = _dynamodb.Table(TABLE_NAME)


def _increment_views() -> int:
    try:
        response = _table.update_item(
            Key={PARTITION_KEY: TRACKING_ID},
            UpdateExpression=(
                'SET #views = if_not_exists(#views, :start) + :inc'
            ),
            ExpressionAttributeNames={
                '#views': 'views'
            },
            ExpressionAttributeValues={
                ':inc': Decimal(1),
                ':start': Decimal(0)
            },
            ReturnValues='UPDATED_NEW',
        )
        return int(response['Attributes']['views'])

    except ClientError as exc:
        logger.error(
            'Unable to update views counter: %s',
            exc
        )
        raise


def lambda_handler(event: Dict, context):
    logger.info('Received event: %s', event)

    method = (
        event.get('httpMethod')
        or event.get('requestContext', {})
        .get('http', {})
        .get('method')
    )

    if method and method.upper() != 'GET':
        return {
            'statusCode': 405,
            'body': 'Method not allowed',
        }

    counter_value = _increment_views()
    logger.info('Updated counter to %s', counter_value)

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps({
            'views': counter_value
        }),
    }
