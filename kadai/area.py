def lambda_handler(event, context):
    try:
        base = float(event.get("base"))
        height = float(event.get("height"))

        area = (base * height) / 2
        return area

    except (TypeError, ValueError) as e:
        return {
            "statusCode": 400,
            "body": {
                "error": f"Invalid input: {str(e)}"
            }
        }