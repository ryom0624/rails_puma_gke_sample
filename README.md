# Set up


## Common
```
$ vagrant up --provision
$ vagrant ssh
$ sudo su
```

## kubernetes(minikube)

```
# minikube start --vm-driver=none

# sudo kubeadm reset -f && sudo /usr/bin/kubeadm init --config /var/lib/kubeadm.yaml --ignore-preflight-errors=DirAvailable--etc-kubernetes-manifests --ignore-preflight-errors=DirAvailable--data-minikube --ignore-preflight-errors=Port-10250 --ignore-preflight-errors=FileAvailable--etc-kubernetes-manifests-kube-scheduler.yaml --ignore-preflight-errors=FileAvailable--etc-kubernetes-manifests-kube-apiserver.yaml --ignore-preflight-errors=FileAvailable--etc-kubernetes-manifests-kube-controller-manager.yaml --ignore-preflight-errors=FileAvailable--etc-kubernetes-manifests-etcd.yaml --ignore-preflight-errors=Swap --ignore-preflight-errors=CRI

# docker build -t rails_puma_web:latest containers/nginx/
# docker build -t rails_puma_app:latest .

# kubectl exec -it db -- mysql -uroot -ppassword -e"CREATE USER sample_user IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON *.* TO 'sample_user'@'%'; FLUSH PRIVILEGES;"

# kubectl exec -it web -c rails rails db:create
# kubectl exec -it web -c rails rails db:migrate

# kubectl rollout status statefulset web
# kubectl rollout history statefulset web
# kubectl rollout undo statefulset web
```

## docker-compose
```
# docker-compose build

# docker-compose up -d

# docker-compose exec db  mysql -uroot -ppassword -e"GRANT ALL PRIVILEGES ON *.* TO 'sample_user'@'%'; FLUSH PRIVILEGES;"

# docker-compose exec app rails db:create
# docker-compose exec app rails db:migrate
```


# commands

## gcloud
If you want to use `gcloud`, put `gcloud init` on your console.
```
# gcloud auth configure-docker
# gcloud auth login
# docker tag [IMAGE] asia.gcr.io/[PROJECT_ID]/[IMAGE]
# docker tag docker_app:latest asia.gcr.io/testing-190408-237002/rails_puma_gke_sample_web:v0.1
# docker push asia.gcr.io/[PROJECT_ID]/[IMAGE]
# docker push asia.gcr.io/testing-190408-237002/rails_puma_gke_sample_web
```

## useful command
exitedになったコンテナを削除
`# docker container rm $(docker container ps -a -f status=exited -q)`

railsで特定のファイルの変更
`# docker image build -t [IMAGE_NAME]:[new_tag] .`


### kubernetes
```
# kubectl apply -f k8s/ --prune --all
# kubectl get deployment,svc,pods,pvc
# kubectl get services
# minikube service list

// minikubeのtype:LoadBalancerを使ったときのIPの確認
# minikube service sample-lb --url
http://10.0.2.15:30080

// podのログ
# stern "web-\w"

// 複数コンテナ
# kubectl exec -it web_pod -c rails /bin/bash

// 引数のあるexec
# kubectl exec -it db -- mysql -uroot -ppassword

// 強制削除
# kubectl delete pods [podname] --grace-period=0 --force

// sample_guide
#  for PODNAME in `kubectl get pods -l app=sample-app -o jsonpath='{.items[*].metadata.name}'`; do kubectl  exec -it ${PODNAME} -- cp /etc/hostname /usr/share/nginx/html/index.html; done
```



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
