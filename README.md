# girf-calc
A matlab toolkit for gradient impulse response function (girf) calculation based on field monitoring data obtained using a field camera (Skope MRT) and a pulse sequence developed in pulseq (Layton et al MRM 2017).  
The calculation is done following the recipe provided in Vannesjo et al MRM 2013. The toolkit relies on the matlab I/O interface provided by Skope and the matlab open-source pulseq. 
You may look at the demo script, `skope_girf.m`, to grab an idea of how this toolkit can be used to calculate girf provided the Skope data and the .seq file (defining the input gradients). 
* NOTE: The .kspha file (for the corresponding Skope data) is too large to upload to github.

### Copyright & License Notice
This software is copyrighted by the Regents of the University of Minnesota. It can be freely used for educational and research purposes by non-profit institutions and US government agencies only. 
Other organizations are allowed to use this software only for evaluation purposes, and any further uses will require prior approval. The software may not be sold or redistributed without prior approval. 
One may make copies of the software for their use provided that the copies, are not sold or distributed, are used under the same terms and conditions. 
As unestablished research software, this code is provided on an "as is'' basis without warranty of any kind, either expressed or implied. 
The downloading, or executing any part of this software constitutes an implicit agreement to these terms. These terms and conditions are subject to change at any time without prior notice.
