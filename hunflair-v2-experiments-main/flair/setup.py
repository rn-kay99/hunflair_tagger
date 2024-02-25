from setuptools import find_packages, setup

with open("requirements.txt") as f:
    required = f.read().splitlines()

# Füge hier den Pfad zu sys.path hinzu
import sys
sys.path.append('/hunflair_tagger/flair')

setup(
    name="flair",
    version="0.12.2",
    description="A very simple framework for state-of-the-art NLP",
    long_description=open("README.md", encoding="utf-8").read(),
    long_description_content_type="text/markdown",
    author="Alan Akbik",
    author_email="alan.akbik@gmail.com",
    url="https://github.com/flairNLP/flair",
    packages=find_packages(exclude="tests"),  # same as name
    license="MIT",
    install_requires=required,
    include_package_data=True,
    python_requires=">=3.7",
)
