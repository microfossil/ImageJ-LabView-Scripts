# ImageJ Scripts
In this repository are stored *ImageJ* scripts that were developed for automated microfossil images processing and segmentation.

* **AutoRadio_Segmenter.ijm**: Automated processing of a root folder ("Core"), containing subfolders ("Samples") of images (Fields of View, **a**) that will invert, create Region of Interests (ROIs, **b**) for each particle and segment and save them as individual images into separate subfolders corresponding to the different "Samples" of the processed root "Core" folder. For more information: https://theguyonhismicroscope.wordpress.com/autoradio-segmenter/

![alt text](https://theguyonhismicroscope.files.wordpress.com/2020/01/sans-titre.jpg?w=2046 "MorFo steps")

* **MorFo_.ijm**: Automated processing of a folder of images (**a**) that will binarise them, separate particles that are in contact with each other (**b**), measure several morphological parameters for each particle (**c**), and export processed images and results in two tables: one for each particle, and one for each sample (averaged). For more information: https://theguyonhismicroscope.wordpress.com/morfo/

![alt text](https://theguyonhismicroscope.files.wordpress.com/2019/12/fig02.jpg?w=2046 "MorFo steps")

***

**Ni Vision / LabView Scripts**

* **PoreViewG.vascr**: Automated processing of images of crushed benthic foraminifera *Globobulimina* species that will binarise the original images (**a** and **b**), reconstruct the tests' fragments and measure their porosity(**c**). It will export the results in a table. The .zip file contain the .vascr script and a .docx description of the script.

![alt text](https://theguyonhismicroscope.files.wordpress.com/2019/12/sans-titre.jpg?w=2046 "PoreViewG steps")
