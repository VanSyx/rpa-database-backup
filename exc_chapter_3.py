import os
import smtplib
import shutil
import schedule
import time
from datetime import datetime
from email.message import EmailMessage
from dotenv import load_dotenv


load_dotenv()
       
email_sender = os.getenv("email_sender")
email_password = os.getenv("email_password")
email_receiver = os.getenv("email_receiver")
db_path = os.getenv("db_path")

backup_dir = os.path.join(os.path.expanduser("~"), "Documents", "RPA")
os.makedirs(backup_dir, exist_ok=True)

def send_email(subject, message):
    mesg = EmailMessage()
    mesg.set_content(message)
    mesg["Subject"] = subject
    mesg["From"] = email_sender
    mesg["To"] = email_receiver
    
    try:
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as smtp:
            smtp.login(email_sender, email_password)
            smtp.send_message(mesg)
        print("Đã gửi email thành công")
    except Exception as e:
        print(f"Gửi email thất bại : {e}")    
    
def backup_database():
    now = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    backup_db = os.path.join(backup_dir, f"RPA_{now}.sql")
    
    try:
        shutil.copy2(db_path, backup_db)
        send_email(
            subject="Bản sao lưu cơ sở dữ liệu RPA thành công",
            message=f"Cơ sở dữ liệu đã được sao lưu thành công tại {backup_db}"
        )
    except Exception as e:
        send_email("Bản sao lưu cơ sở dữ liệu RPA thất bại",
                   message=f"Sao lưu cơ sở dữ liệu thất bại: {e}")

schedule.every().day.at("00:00").do(backup_database)

print("00h00 hàng ngày sẽ sao lưu cơ sở dữ liệu RPA")
while True:
    schedule.run_pending()
    time.sleep(60)