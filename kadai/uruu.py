def lambda_handler(event, context):
    uruu_years = []
    for year in range(1, 2101):
        if (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0):
            uruu_years.append(year)

    return uruu_years