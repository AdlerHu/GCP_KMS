@ECHO OFF

SET bucket=adler-kms-bucket

rem the file want to encrypt in cloud storage
SET filename=%1

rem the path to store data on host
SET file_path=D:\kms_script

rem the file name after encrypt
SET encrypted_filename=%filename%-encrypted

rem download file want to encrypt from cloud storage
CALL gsutil cp gs://%bucket%/%filename% %file_path%\%filename%

rem remove uncrypt data on cloud storage
CALL gsutil rm -f gs://%bucket%/%filename%

rem encrypt data
CALL gcloud kms encrypt --key key3 --keyring adler-key-ring --location asia-east1 --plaintext-file  %file_path%\%filename% --ciphertext-file %file_path%\%encrypted_filename%
	
rem upload encrypted data
CALL gsutil cp %file_path%\%encrypted_filename% gs://%bucket%/%encrypted_filename%

rem remove encrypted data on host
DEL %file_path%\%encrypted_filename%
ECHO 'done'
