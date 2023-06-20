import os
from dotenv import load_dotenv

load_dotenv()

secret_key = os.getenv('APP_SECRET_KEY')
db_host = os.getenv('DB_HOST')
db_user = os.getenv('DB_USER')
db_pass = os.getenv('DB_PASS')
db_name = os.getenv('DB_NAME')

print(db_host, db_user, db_pass, db_name)