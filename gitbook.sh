cd security-kb-gitbook
docker run -v "$PWD:/gitbook" -p 4000:4000 billryan/gitbook:base gitbook serve
docker run --rm -v "$PWD:/gitbook" -p 4000:4000 billryan/gitbook gitbook serve
