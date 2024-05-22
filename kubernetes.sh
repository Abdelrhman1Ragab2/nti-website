#!/bin/bash
kubectl apply -f secret.yaml --validate=false 
kubectl apply -f configmap.yaml --validate=false
kubectl apply -f postgress_serves.yaml --validate=false
kubectl apply -f postgress.yaml --validate=false  
kubectl apply -f backend.yaml --validate=false
kubectl apply -f backend_service.yaml --validate=false  
kubectl apply -f frontend.yaml --validate=false 
kubectl apply -f frontend_service.yml --validate=false 
