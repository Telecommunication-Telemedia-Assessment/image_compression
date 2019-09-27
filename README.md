# Evaluation of Intra-coding based Image Compression
This repository contains the code to reproduce the evaluation experiments of the paper "Evaluation of Intra-coding based image compression" by Steve Göring and Alexander Raake; [Audiovisual Technology Group; Technische Universität Ilmenau, Germany](https://www.tu-ilmenau.de/en/audio-visual-technology/).

A short overview of the Dataset and demo of the compression algorithms is available at [Demo](https://telecommunication-telemedia-assessment.github.io//image_compression)

Main goal of the conducted evaluation is to compare the suitability of different intra frame algorithms of current state of the art video codecs with jpeg compression.

If you use the dataset or the provided code please cite the following paper:
```
@inproceedings{goering2019Intra,
  title={Evaluation of Intra-coding based image compression},
  author={Steve G{\"{o}}ring and Alexander Raake},
  booktitle={Visual Information Processing (EUVIP), 2019 8th European Workshop on},
  pages={1--6},
  year={2019},
  organization={IEEE},

}
```

## Dataset
The full dataset is available on https://zenodo.org/record/3459357#.XY4DGB9fhhE.
It can be automatically downloaded via "./download.sh".

## Requirements

The code is only tested on Ubuntu 18.04, to perform the same evaluation that is presented in the paper you need

* ffmpeg 4.1.3 (provided in the repository as tar.gz, extract it so that ffmpeg executable is in <REPO>/ffmpeg-4.1.3-amd64-static/ffmpeg)
* convert tool (part of imagemagick, install via `sudo apt install imagemagick`)

## Encoding images
In the presented paper, all possible quality variants of the raw/png images are processed,
however if you want to use it for real world applications this is probably not required.

To encode a given image (or all images of the dataset) you need to run:
```
./encode.sh <IMAGENAME>
```

If you want to perform the encoding for all images of a larger dataset please use GNU parallel or similar tools.

Encoding of one high resolution image will take some time.
