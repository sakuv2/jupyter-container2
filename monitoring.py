import subprocess
import shutil
import os
from time import sleep
from pathlib import Path

PROJECT_DIR = '/root/pyprojects'
INSTALLE_DIR = '/root/.local/share/jupyter/kernels'

project_path = Path(PROJECT_DIR)
kernel_path = Path(INSTALLE_DIR)

if not project_path.exists():
    project_path.mkdir(parents=True)


def start_jupyter():
    cmd = "/usr/local/bin/jupyter lab"
    p = subprocess.Popen(cmd.split(), stderr=subprocess.STDOUT)
    print('jupyter start')
    return p


def get_kernel():
    _ks = []
    for d in project_path.iterdir():
        sleep(.1)
        if (d/".venv/bin/python").exists():
            cmd = f"{str(d)}/.venv/bin/python -c 'import ipykernel'"
            rc = subprocess.run(cmd, shell=True,
                                stdout=subprocess.DEVNULL,
                                stderr=subprocess.DEVNULL).returncode
            if rc == 0:
                _ks.append(d)
    return set(_ks)


def set_kernel(ks):
    # 一旦全部消す
    if kernel_path.exists():
        shutil.rmtree(kernel_path)
    kernel_path.mkdir(parents=True)

    for k in ks:
        k.name
        cmd = f"{str(k)}/.venv/bin/python -m ipykernel install --name {k.name} --user"
        subprocess.call(cmd.split())


ks = get_kernel()
set_kernel(ks)
p = start_jupyter()


def loop():
    global p, ks

    sleep(1)

    _ks = get_kernel()

    if ks != _ks:
        set_kernel(_ks)
        print('jupyter restart')
        p.kill()
        sleep(5)
        p = start_jupyter()
        ks = _ks


try:
    while True:
        loop()
except KeyboardInterrupt:
    p.kill()
