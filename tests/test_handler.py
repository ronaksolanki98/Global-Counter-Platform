from unittest.mock import MagicMock

import pytest

from app.backend import handler


def test_lambda_handler_get(monkeypatch):
    handler._table = MagicMock()
    handler._table.update_item.return_value = {
        'Attributes': {'views': 5}
    }

    event = {'httpMethod': 'GET'}
    response = handler.lambda_handler(event, {})

    assert response['statusCode'] == 200
    assert 'views' in response['body']


def test_lambda_handler_non_get(monkeypatch):
    event = {'httpMethod': 'POST'}
    response = handler.lambda_handler(event, {})
    assert response['statusCode'] == 405
