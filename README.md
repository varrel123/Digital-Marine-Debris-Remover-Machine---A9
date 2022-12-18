# DIGITAL MARINE DEBRIS REMOVER MACHINE
<!--Strong-->
**Digital Marine Debris Remover Machine** adalah sebuah mesin yang dibuat untuk menangani sampah laut yang merupakan masalah signifikan yang juga mempengaruhi kesehatan lautan kita dan hewan yang hidup di dalamnya. Menghilangkan sampah laut penting untuk melindungi ekosistem laut dan memastikan keberlanjutan lautan kita. 

Mesin ini terdapat kail dengan jaring yang dapat dikontrol maju, mundur, kanan dan kiri sesuai yang diinginkan, kemudian dapat memenurukan kail dengan jaring tersebut untuk mencari dan mengambil sampah yang ada dengan tambahan fitur sensor yang mendeteksi sampah yang penuh dalam jaring.


## Tujuan

Proyek ini dibuat dengan adanya tujuan sebagai berikut:
<!-- OL -->
1. Menyelesaikan final project Praktikum Perancangan Sistem Digital sebagai Mahasiswa Teknik Komputer Universitas Indonesia
2. Mengimplementasikan FPGA dan VHDL untuk membuat sebuah sistem digital.
3. Mengimplementasikan Mealy State Machine pada sebuah sistem digital yang solutif dan inovatif

## Getting Started

Instruksi ini akan membuat sebuah salinan proyek ini di komputer Anda.

### Prerequisites

Hal-hal apa yang perlu diinstall untuk mengoptimalkan simulasi proyek

<!-- OL -->
1. VHDL compiler (e.g. ModelSim)
2. Simulation tool (e.g. ModelSim, Quartus)


### Installing

Panduan untuk menginstal proyek di mesin lokal Anda

<!-- OL -->
1. $ git clone https://github.com/varrel123/Digital-Marine-Debris-Remover-Machine---A9.git

#### Description

Terdapat 5 buah input dan 3 buah output pada proyek ini, inputnya antara lain:
<!-- UL -->
* Machine       : Kondisi untuk menyalakan dan mematikan mesin
* Clock (CLK)   : Clock 
* Sensor (Sen)  : Sensor yang digunakan untuk mendeteksi apakah sampah penuh atau tidak
* Direction     : Arah gerak dari hook yang digunakan untuk mencari debris
* Hook          : Kondisi apakah hook dengan net dalam kondisi naik atau turun

Sementara itu, outputnya adalah:
* Sampah  : The debris / Sampah laut yang merupakan output utama
* Lamp    : Led light untuk arah gerak atau direction
* Alarm   : Alarm bells untuk Hook 


## Built With

- VSC
- ModelSim
- Quartus

## Presentation YouTube link

https://www.youtube.com/watch?v=1N0_GKdwXbw

## Authors

- Muhammad Fathan Muhandis
- Mohammad Varrel Bramasta
- Muhammad Aqil Muzakky
- Aliefya Fikri Ihsani

