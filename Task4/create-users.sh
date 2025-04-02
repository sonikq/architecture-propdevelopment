#!/bin/bash

# Создание пользователя client-developer
echo "Creating 'client-developer' certificate..."
openssl genrsa -out client-developer.key 2048
openssl req -new -key client-developer.key -out client-developer.csr -subj "/CN=client-developer/O=developers"
openssl x509 -req -in client-developer.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out client-developer.crt -days 365

# Добавляем пользователя в kubeconfig
echo "Adding client-developer to kubeconfig..."
kubectl config set-credentials client-developer --client-certificate=$(pwd)/client-developer.crt --client-key=$(pwd)/client-developer.key
kubectl config set-context client-developer-context --cluster=minikube --namespace=client --user=client-developer

# Создание пользователя security-user
echo "Creating 'security-user' certificate..."
openssl genrsa -out security-user.key 2048
openssl req -new -key security-user.key -out security-user.csr -subj "/CN=security-user/O=security"
openssl x509 -req -in security-user.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out security-user.crt -days 365

# Добавляем пользователя в kubeconfig
echo "Adding security-user to kubeconfig..."
kubectl config set-credentials security-user --client-certificate=$(pwd)/security-user.crt --client-key=$(pwd)/security-user.key
kubectl config set-context security-user-context --cluster=minikube --namespace=production --user=security-user

# Выводим список пользователей в kubeconfig
echo "Users created:"
kubectl config get-contexts