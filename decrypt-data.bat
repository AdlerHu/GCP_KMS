@ECHO OFF
rem 從cloud storage下載加密檔,解密後存在本地 

SET bucket=adler-kms-bucket
rem the file want to encrypt in cloud storage
SET encrypted_filename=%1
rem the path to store data on host
SET file_path=D:\kms_script
rem the file name after decrypt
SET decrypted_filename=%encrypted_filename:-encrypted=%

rem Download encrypted file from cloud storage
CALL gsutil cp gs://%bucket%/%encrypted_filename% %file_path%\%encrypted_filename%

rem decrypt
CALL gcloud kms decrypt --key key3 --keyring adler-key-ring --location asia-east1 --ciphertext-file %file_path%\%encrypted_filename% --plaintext-file %file_path%\%decrypted_filename%

rem remove encrypted file
DEL %file_path%\%encrypted_filename%