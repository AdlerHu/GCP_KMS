#!/bin/sh
# 從cloud storage下載加密檔,解密後存在本地 

bucket='adler-kms-bucket'
# the file want to encrypt in cloud storage
encrypted_filename=$1
# the path to store data on host
file_path='/home/adlerhu/kms_script'
# the file name after decrypt
decrypted_filename=${encrypted_filename%-e*}

# Download encrypted file from cloud storage
gsutil cp gs://${bucket}/${encrypted_filename} ${file_path}/${encrypted_filename}

# decrypt
gcloud kms decrypt \
    --key key3 \
    --keyring adler-key-ring \
    --location asia-east1  \
    --ciphertext-file ${file_path}/${encrypted_filename} \
    --plaintext-file ${file_path}/${decrypted_filename}

# remove encrypted file
rm -f ${file_path}/${encrypted_filename}
