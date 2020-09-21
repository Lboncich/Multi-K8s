docker build -t lboncich/multi-client:latest -t lboncich/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t lboncich/multi-server:latest -t lboncich/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t lboncich/multi-worker:latest -t lboncich/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push lboncich/multi-client:latest
docker push lboncich/multi-server:latest
docker push lboncich/multi-worker:latest

docker push lboncich/multi-client:$SHA
docker push lboncich/multi-server:$SHA
docker push lboncich/multi-worker:$SHA

kubectl apply -f k8s # take all configs in k8 directory and apply
kubectl set image deployments/server-deployment server=lboncich/multi-server:$SHA
kubectl set image deployments/client-deployment client=lboncich/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=lboncich/multi-worker:$SHA