#!/bin/sh
# 從cloud storage 下載檔案,加密後將加密檔上傳cloud storage

bucket='adler-kms-bucket'

# the file want to encrypt in cloud storage
#filename='datacenter-cfe.csv'
filename=$1

# the path to store data on host
file_path=/home/adlerhu/kms_script
# the file name after encrypt
encrypted_filename=${filename}-encrypted

# download file want to encrypt from cloud storage
gsutil cp gs://${bucket}/${filename} ${file_path}/${filename}

# remove uncrypt data on cloud storage
gsutil rm -f gs://${bucket}/${filename}

# encrypt data
gcloud kms encrypt \
    --key key3 \
    --keyring adler-key-ring \
    --location asia-east1  \
    --plaintext-file  ${file_path}/${filename} \
    --ciphertext-file ${file_path}/${encrypted_filename}

# upload encrypted data
gsutil cp ${file_path}/${encrypted_filename} gs://${bucket}/${encrypted_filename}

# remove encrypted data on host
rm -f ${file_path}/${encrypted_filename}
echo 'done'
