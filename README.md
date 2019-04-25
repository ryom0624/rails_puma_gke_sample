# Common
`$ vagrant up --provision`

`$ vagrant ssh`

`$ sudo su `

## gcloud
If you want to use `gcloud`, put `gcloud init` on your console.
`$ gcloud auth configure-docker`

## useful command
exitedになったコンテナを削除
`# docker container rm $(docker container ps -a -f status=exited -q)`

railsで特定のファイルの変更
`# docker image build -t docker_app:[new_tag] .`


# local development for docker-compose

```
# docker-compose build

# docker-compose up -d

# docker-compose exec db  mysql -uroot -ppassword -e"GRANT ALL PRIVILEGES ON *.* TO 'sample_user'@'%'; FLUSH PRIVILEGES;"

# docker-compose exec app rails db:create
# docker-compose exec app rails db:migrate
```

# local development for kubernetes(minikube)
`# minikube start --vm-driver=none`

```
# sudo kubeadm reset -f && sudo /usr/bin/kubeadm init --config /var/lib/kubeadm.yaml --ignore-preflight-errors=DirAvailable--etc-kubernetes-manifests --ignore-preflight-errors=DirAvailable--data-minikube --ignore-preflight-errors=Port-10250 --ignore-preflight-errors=FileAvailable--etc-kubernetes-manifests-kube-scheduler.yaml --ignore-preflight-errors=FileAvailable--etc-kubernetes-manifests-kube-apiserver.yaml --ignore-preflight-errors=FileAvailable--etc-kubernetes-manifests-kube-controller-manager.yaml --ignore-preflight-errors=FileAvailable--etc-kubernetes-manifests-etcd.yaml --ignore-preflight-errors=Swap --ignore-preflight-errors=CRI
```

`# minikube detele`

## use kompose

`# docker run -d -p 5000:5000 -v ~/.dockerregistry:/var/lib/docker/registry --restart always --name registry registry:2`

`# docker tag [[image:tag]] [[localhost:5000/image:tag]]`
example
`docker tag docker_web:latest localhost:5000/docker_web:v1`

`# docker push [[localhost:5000/image:tag]] `

`# kompose convert`

```web-deployment.yaml
spec:
  containers:
  - image: localhost:5000/docker_web:v1
    name: web
    ports:
    - containerPort: 3000
    resources: {}
  restartPolicy: OnFailure  // Before : Always
```

```web-service.yaml
spec:
  ports:
  - name: "3000"
    port: 3000
    targetPort: 3000
  selector:
    io.kompose.service: web
  type: NodePort     // Add
```

```docker-compose.yml
  // delete vloumes
  web:
    image: localhost:5000/docker_web:v1
    ports:
      - "3000:3000"
    links:
      - db
```

`# kompose up`


# use kubernetes
`# kubectl get deployment,svc,pods,pvc`

`# kubectl exec -it [[pods name]] rails db:create`

`# kubectl apply -f k8s/ --prune --all`


`# kubectl get services`

`# minikube service list`


```

# kubectl exec -it web_pod -c rails /bin/bash
$ kubectl exec -it db -- mysql -uroot -ppassword

CREATE USER sample_user IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'sample_user'@'%';
FLUSH PRIVILEGES;
# kubectl exec -it db -- mysql -uroot -ppassword -e"CREATE USER sample_user IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON *.* TO 'sample_user'@'%'; FLUSH PRIVILEGES;"

# kubectl exec -it db -- mysql -uroot -ppassword -e"CREATE USER sample_user IDENTIFIED BY 'password';"
# kubectl exec -it db -- mysql -uroot -ppassword -e"GRANT ALL PRIVILEGES ON *.* TO 'sample_user'@'%';"
# kubectl exec -it db -- mysql -uroot -ppassword -e"FLUSH PRIVILEGES;"

$ kubectl exec -it web -c rails rails db:create
$ kubectl exec -it web -c rails rails db:migrate


$ kubectl apply -f web-service.yaml
$ minikube service list

$ kubectl delete pods [podname] --grace-period=0 --force
```

deploymentを変更

`# kubectl apply -f k8s/`


