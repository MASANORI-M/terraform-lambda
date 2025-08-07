import json
import boto3
import uuid
from datetime import datetime

def lambda_handler(event, context):
    # 1. 入力パラメータのチェック
    if "reviewText" not in event:
        return {
            'statusCode': 400,
            'body': json.dumps('問い合わせ内容が入力されていません')
        }
    if "userName" not in event:
        return {
            'statusCode': 400,
            'body': json.dumps('お名前が入力されていません')
        }
    if "mailAddress" not in event:
        return {
            'statusCode': 400,
            'body': json.dumps('メールアドレスは必須です')
        }
    
    # 2.入力パラメータの取得
    review_text = event["reviewText"]
    user_name = event["userName"]
    mail_address = event["mailAddress"]
    
    # 3.idの生成（uuidを取得）
    save_data_id = str(uuid.uuid4())
    
    # 4.タイムスタンプの取得
    timestamp = datetime.now().isoformat()
    
    # 5.DynamoDBリソースの初期化
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('InquiryTable')
    
    # 6.DynamoDBに更新するitemの内容を辞書で定義
    saveData = {
        'id': save_data_id,
        'reviewText': review_text,
        'userName': user_name,
        'mailAddress': mail_address,
        'createdAt': timestamp,
        'updatedAt': timestamp
    }
    
    try:
        # 7.DynamoDBにデータを保存
        table.put_item(Item=saveData)
    except Exception as e:
        # 8.エラーが発生した場合、ステータスコード500（内部サーバエラー）を返す
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error saving item to DynamoDB: {str(e)}')
        }
    
    # 9.ステータスコード200（正常終了）を返す
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': 'inquiry saved successfully!',
            'id': save_data_id
        })
    }