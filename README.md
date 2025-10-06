
``` bash 
./tsl/
├── ca.crt                  # Публичный ключ (Корневой сертификат (CA) ✅)
├── ca.key                  # Приватный ключ CA (держим в секрете) 
├── kafka.csr               # Сертификат брокера (подписан CA) ✅
├── kafka.keystore.jks      # Хранилище брокера (ключи и сертификаты) ✅
├── kafka-signed.crt        # Сертификат брокера (подписан CA) ✅
├── kafka.truststore.jks    # Хранилище доверенных CA ✅
└── key-creds               # Пароли для JKS-файлов ✅
```

For generating these files - just run script
``` bash 
sh run_all_scripts.sh tsl <passkey>
```

``` bash 
ca.crt - used to add public (whom is signing) inforation for signed certificate (public key)
ca.key - used to sign certificate 
```