# vivado_2022.1_docker

This is the docker image for Vivado 2022.1, with support for Zynq-7 devices only. 

Creating a new build of the the docker image, the following steps shall be followed:

1. Download installer from Xilinx webpage, this requires login, and save the file in the root of this project:

```
https://www.xilinx.com/member/forms/download/xef.html?filename=Xilinx_Unified_2022.1_0420_0327.tar.gz
```

2. Run the `extract.sh` script

3. Build docker image

```
docker build -t ghcr.io/luftkode/vivado_2022.1_docker:<VERSION> .
```

4. publish docker image

```
docker push ghcr.io/luftkode/vivado_2022.1_docker:<VERSION>
```
