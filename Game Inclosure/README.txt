Given sprite sheets with size 1024 * 1024, we want to pack different size rectangle image. We want to pack as many as images in one sheet possible without overlapping each image. Given a list of images, output how to place the sprite and the least number of sheet used in following format.

Input:
864x480 410x321 188x167 315x274 229x163 629x236 39x32 193x56 543x155

Output:
sheet 0
864x480 0 0
629x236 0 480
315x274 0 716
543x155 315 716
229x163 629 480
193x56 315 871
39x32 864 480

sheet 1
410x321 0 0
188x167 0 321
