Unit Test;

interface

uses
  jmorecfg, jpeglib;

const
  MaxWidth = 175;
  MaxLines = 4;
type
  RGB_pixel = packed record
             Case byte of
             0:(r,g,b : byte);
             1:(color:array[0..2] of byte);
             2:(cyan,magenta,yellow : byte);
             3:(Y,Cb,Cr : byte);
           end;
var
  image_line : array[0..MaxLines-1,0..MaxWidth-1] of RGB_pixel;
var
  image_buffer : JSAMPROW;      { Points to large array of R,G,B-order data }
  image_height : int;           { Number of rows in image }
  image_width : int;            { Number of columns in image }
var
  current_line : int;
type
  jmp_buf = pointer;

  { This routine does the output }
  procedure put_scanline_someplace(buffer : JSAMPROW; row_stride : int);

  { define an error recovery point. Return 0 when OK }
  function setjmp(setjmp_buffer : jmp_buf) : int;

  { Return control to the setjmp point }
  procedure longjmp(setjmp_buffer : jmp_buf; flag : int);

  procedure save_color_map(cinfo : j_decompress_ptr);

  procedure define_image_params;

  procedure  pre_decode;

  procedure  post_decode;

implementation

var
  outfile : file;

{ This routine does the output }
procedure put_scanline_someplace(buffer : JSAMPROW; row_stride : int);
var
  line_size : int;
begin
  WriteLn(output, current_line:3, '. line of image data read');
  line_size := 3 * MaxWidth;

  BlockWrite(outfile, buffer^, row_stride);

  if line_size > row_stride then
    line_size := row_stride;

  if current_line < MaxLines then
    Move(buffer^, image_line[current_line], line_size);
  Inc(current_line);
end;

{ define an error recovery point. Return 0 when OK }
function setjmp(setjmp_buffer : jmp_buf) : int;
begin
  setjmp := 0;
  current_line := 0;
end;

{ Return control to the setjmp point }
procedure longjmp(setjmp_buffer : jmp_buf; flag : int);
begin
  Halt(2);
end;

procedure define_image_params;
var
  i, j : JDIMENSION;
  r0, b0, g0 : byte;
begin
  r0 := 255;
  g0 := 255;
  b0 := 255;
  for j := 0 to pred(MaxLines) do
  begin
    for i := 0 to Pred(MaxWidth) do
    with image_line[j][i] do
    begin
      r := r0;
      Dec(r0);
      g := g0;
      b := b0;
    end;
    Dec(b0, 16);
  end;
  image_buffer := JSAMPROW(@image_line);
  image_height := MaxLines;
  image_width := MaxWidth;
end;


procedure pre_decode;
begin
  Assign(outfile, 'PasJpeg.raw');
  ReWrite(outfile, 1);
end;

procedure save_color_map(cinfo : j_decompress_ptr);
var
  VGAPalette : Array[0..255] of RGB_pixel;
  i, count : int;
begin
  count := cinfo^.actual_number_of_colors;
  if (cinfo^.colormap <> NIL) and (count > 0) then
  begin
    if count > 256 then
      count := 256;
    if (cinfo^.out_color_components = 3) then
      for i := 0 to pred(count) do
      begin
        VGAPalette[i].r := cinfo^.colormap^[0]^[i];
        VGAPalette[i].g := cinfo^.colormap^[1]^[i];
        VGAPalette[i].b := cinfo^.colormap^[2]^[i];
      end
    else { Grayscale colormap (only happens with grayscale quantization) }
      for i := 0 to pred(count) do
      begin
        VGAPalette[i].r := cinfo^.colormap^[0]^[i];
        VGAPalette[i].g := cinfo^.colormap^[0]^[i];
        VGAPalette[i].b := cinfo^.colormap^[0]^[i];
      end;
    BlockWrite(outfile, VGAPalette, 3*count);
  end;
end;

procedure  post_decode;
begin
  Close(outfile);
end;

end.
f�����]���M�u��� ��&    �U����}f�f���GP�e�u�V�eEG�^�]��^�]��Ëv��X�M��M��f�É�Ju��� ��&    ��&    U����u&f�f��&�FP�e�eE&F�ƉË}&�W&�G�E�&�G�E�&�X�M��M��f�É�Ju��� �t& �U���0�}�u�E;G
�  F
���  �];_��   ^����   SP�E�� }�؉E��E�    �
�E�    �E�E�� }�؉E��E�    �
�E�    �E�X;G
�F
�E��	�G
+E�E�X;G�F�E��	�G+E�E��E�+E��E�E�+E�E��e��e�f��F�EЋE��e�E��vƋG�EԋE��e�E�ǉ��u�1ҋE�   ��E�U��M��M��f�]ԉߋU�U؋u��M�u��� �t& U���8�}�u�E;G
�  F
���  �];_�  ^����   SP�E�� }�؉E��E�    �
�E�    �E�E�� }�؉E��E�    �
�E�    �E�X;G
�F
�E��	�G
+E�E�X;G�F�E��	�G+E�E��E�+E��E�E�+E�E��e��e�f��f��&f�&�F�EȋE��e�E�&�v�&�G�E̋E��e�E�&�Ǉ����u�1ҋE�   ��E�U��M��M��f�]ȉߋU�UЋu��M�u��� �t& �U����}�u�F�E��G�E�f��F
�E�G�E��e�eEE��ǉËV�u��M�f�f;Et&f�����Iu�]���Ju��� ��&    �t& U����}�u�G�E��F�E�f�&�G
�E�&�F�E��e�eEE��Ɖ�&�W�}��M�f�f;Et&f�����Iu�]��Ju��� ��    U���,�E�};G
�  �uF
���   �];_��   ^����   SP�E�� }�؉E��E�    �
�E�    �E�E�� }�؉E��E�    �
�E�    �E�X;G
�F
�E��	�G
+E�E�X;G�F�E��	�G+E�E��E�+E��E�E�+E�E��e��e�f��F�EԋE��e�E��vƋG�E؋E��e�E�ǉ��u܋M�f�f;Et&f�����Iu�]؉ߋU�U܋u��M�u��� ��&    �U���4�u�}�E;F
�  G
���  �];^��   _����   SP�E�� }�؉E��E�    �
�E�    �E�E�� }�؉E��E�    �
�E�    �E�X;F
�G
�E��	�F
+E�E�X;F�G�E��	�F+E�E��E�+E��E�E�+E�E��e��e��E�_�]���E�ǋE�^�]���f��vE��f�ۉ��űM�f�f;Et&f�����Iu�]ԉߋU�Űu��M�u��� �t& �U���$�}f��G�E��e�eEG�ǉE�u�N
�M��N�M�v�M�f�f��f��*e�� }0�e���*E< }0��E��*U�� }0҈U�&f�f��f������}�]�U�� r���@r�?�� r���f�� �f�� �&f�����I�|����E�E�}��M��g����� ��&    �t& U���4�u�}�E;G
��  F
���w  �];_�k  ^���_  SP�E�� }�؉E��E�    �
�E�    �E�E�� }�؉E��E�    �
�E�    �E�X;G
�F
�E��	�G
+E�E�X;G�F�E��	�G+E�E��E�+E��E�E�+E�E��e��e�f��N�W�M܉U؋E��e�E��vƋ�E��e�E�ǉ}ЉuԋM�f�f��f��*e�� }0�e���*E< }0��E΀�*U�� }0҈U�&f�f��f������}�]�Ù� r���@r�?�� r���f�� �f�� �&f�����I�|����E�EЋ}ЋU�Uԋu��M��^����� �U����u�}f��F
�E�F�E��G�E��e�eEG�ǉE�v�M�f�f;E�t   f��f��*e�� }0�e���*E< }0��E��*U�� }0҈U�&f�f��f������}�]�U�� r���@r�?�� r���f�� �f�� �&f�����I�r����E�E�}��M��]����� �U���4�}�u�E;G
��  F
����  �];_�u  ^���i  SP�E�� }�؉E��E�    �
�E�    �E�E�� }�؉E��E�    �
�E�    �E�X;G
�F
�E��	�G
+E�E�X;G�F�E��	�G+E�E��E�+E��E�E�+E�E��e��e�f��F�E؋G�E܋E��e�E��vƋ�E��e�E�ǉ}ЉuԋM�f�f;E�t   f��f��*e�� }0�e���*E< }0��E΀�*U�� }0҈U�&f�f��f������}�]�Ù� r���@r�?�� r���f�� �f�� �&f�����I�r����E�EЋ}ЋU�Uԋu��M��T����� ��&    U���$�u�}f��F
�E�F�E��G�E��e�eEG�ǉE��v�M�f�f��f���e����E���U�&f�f��f������*}�� }0�*]�� }0�*U�� }0�}�]�U�� r���@r�?�� r���f�� �f�� �&f�����I�{����E�E��}��M��f����� ��&    �v U���4�u�}�E;G
��  F
���x  �];_�l  ^���`  SP�E�� }�؉E��E�    �
�E�    �E�E�� }�؉E��E�    �
�E�    �E�X;G
�F
�E��	�G
+E�E�X;G�F�E��	�G+E�E��E�+E��E�E�+E�E��e��e�f��F�E؋E��e�E��vƋG�E܋E��e�E�ǉ}ЉuԋM�f�f��f���e����E΀��U�&f�f��f������*}�� }0�*]�� }0�*U�� }0�}�]�Ù� r���@r�?�� r���f�� �f�� �&f�����I�{����E�EЋ}ЋU�Uԋu��M��]����� U����u�}f��F
�E��F�E��G�E��e�eEG�ǉE�v�M�f�f;E�u   f��f���e����E���U�&f�f��f������*}�� }0�*]�� }0�*U�� }0�}�]�U�� r���@r�?�� r���f�� �f�� �&f�����I�q����E�E�}��M��\����� U���4�u�}�E;G
��  F
����  �];_�v  ^���j  SP�E�� }�؉E��E�    �
�E�    �E�E�� }�؉E��E�    �
�E�    �E�X;G
�F
�E��	�G
+E�E�X;G�F�E��	�G+E�E��E�+E��E�E�+E�E��e��e�f��F�E؋G�E܋E��e�E��vƋE��e�E�ǉ}ЉuԋM�f�f;E�u   f��f���e����E΀��U�&f�f��f������*}�� }0�*]�� }0�*U�� }0�}�]�Ù� r���@r�?�� r���f�� �f�� �&f�����I�q����E�EЋ}ЋU�Uԋu��M��S����� ��    U����u�}f��G�E��F�E��F
�E��G
�eE��G�ǉE�v�M�f�f��f���e����E���U�&f�f��f������}�]�U�� r���@r�?�� r���f�� �f�� �&f�����Iu��E�E�}��M�������� ��&    �v U���4�u�}�E;G
�b  F
���V  �];_�J  ^���>  SP�E�� }�؉E��E�    �
�E�    �E�E�� }�؉E��E�    �
�E�    �E�X;G
�F
�E��	�G
+E�E�X;G�F�E��	�G+E�E��E�+E��E�E�+E�E��e��e�f��F�E؋E��e�E��vƋG�E܋E��e�E�ǉ}ЉuԋM�f�f��f���e����E΀��U�&f�f��f������}�]�Ù� r���@r�?�� r���f�� �f�� �&f�����Iu��E�EЋ}ЋU�Uԋu��M������� ��U����u�}f��G�E�F�E��F
�E��G
�eE��G�ǉE�v�M�f�f;EtWf��f���e����E���U�&f�f��f������}�]�U�� r���@r�?�� r���f�� �f�� �&f�����Iu��E�E�}��M�������� �t& U���4�u�}�E;G
�h  F
���\  �];_�P  ^���D  SP�E�� }�؉E��E�    �
�E�    �E�E�� }�؉E��E�    �
�E�    �E�X;G
�F
�E��	�G
+E�E�X;G�F�E��	�G+E�E��E�+E��E�E�+E�E��e��e�f��F�E؋E��e�E��vƋG�E܋E��e�E�ǉ}ЉuԋM�f�f;EtWf��f���e����E΀��U�&f�f��f������}�]�Ù� r���@r�?�� r���f�� �f�� �&f�����Iu��E�EЋ}ЋU�Uԋu��M��y����� ��&    �t& �U����}�O��f���u�vf�f��f���e����E����U�&f�f��f������:e�v�E�s�M�:E�v*E�<r�E��(�E��#:E�sf�u�(E��}�r
f�E��m��f�E��M�:U�v�E�s�M��E�f��f�U�f��U�f�f�����I�\����� ��&    �t& U���$��fh  �u�u�EP�4Q�����E�x�}��E�x�}��E�x
W�$_�}W�$_���]܃��E܃�
�<$�k  �-d� �Ƀ�
�<$�d  ��f�E���E܃�
�<$�{d  ���E�E�xW�$_�}W�$_���]܃��E܃�
�<$�j  �-d� �Ƀ�
�<$�9d  ��f�E���E܃�
�<$�!d  ���E��E�x�}�f��f���}��u�1��e�f�E�  �]f1ҋ]f�u�fU�r��Ku�M�f�E�fE�sA�u����e���Mu��� ��&    ��    U����E�@;E|�	�E�x�}�E�@&;E|�	�E�x&�}�u�u�EP��c��f�E����EP�EP�EP�}�fW�1������ ��&    �v U���h��fh  �u�u�}�W�tO�����=n� �}ċ=r� �}ȋE�x
W�$_�-v� ��E��P�$_���]��E�xW�$_�-v� ��E��P�$_���]��EH�E��E�    �E�;E��  ����=�� �}̋=�� �}ЋEH�E��E�    �E�;E���  �}�W�}�W�}�W���Eă�
�<$�cb  ��P���Ẽ�
�<$�Nb  ��P�EP�����}�W�}�W�}�W���E��E�����
�<$�b  ��P���Ẽ�
�<$�
b  ��P�EP�M����}�W�}�W�}�W���Eă�
�<$��a  ��P���E��E�����
�<$��a  ��P�EP�	����}�W�}�W�}�W���E��E�����
�<$�a  ��P���E��E�����
�<$�}a  ��P�EP������E��-�� ���E����]̃��E��U���E���U��y����fR�E��U���E���U��y����fR�E��U���E���U��y����fR�O\��fP�u��u��}�W�a�����E�;E�}�E��K����E��-�� ���E����]ċE�;E�}�E�������E�8�u���
   �f��� ��U��u�N�v��f��À�f����eE]��~���� }0�<?~�?�< }0���~���� }0���f�� �f������
 ��    U��u�N�v��f�f;EtO�À�f����eE]��~���� }0�<?~�?�< }0���~���� }0���f�� �f���I������� ��&    �t& U��u�N�v��f��À�f����eE]��~�<?~�?��~���f�� �f�������
 U��u�N�v��f�f;Et5�À�f����eE]��~�<?~�?��~���f�� �f������ ��&    �v U��u�N�v��f��À�f����eE]�� }0�< }0��� }0���f�� �f�������
 U��u�N�v��f�f;Et5�À�f����*e*E*]�� }0�< }0��� }0���f�� �f������ ��&    �v U���u�F�v�}�f��f�À=?  t"1ҹ   ���o&������w����1ҹ   �������� ��    U����u�}�N��v΃���f�&f�����Iu��� ��&    ��&    �U���,��fh  �E�p
�E�p�}�W��I�����}�W�EP�����E�8�u���
   �f��� ��&    �U����u�}�F�E��V
�N�ˋF��v�+u�V��f�&f���+u�Iu�^��Ju��� ��&    �v U���,��fh  �E�p
�E�p�}�W�.I�����}�W�EP�~����E�8�u���
   �f��� ��&    �U����u�}�F�E��V
�N�ˋ�vƃ�V��f�&f���u�Iu�^��Ju��� ��&    ��    U���,��fh  �E�p
�E�p�}�W�H�����}�W�EP�~����E�8�u���
   �f��� ��&    �U����u�}�F�E��N
�V�ˋ�vƃ�V��f�&f�����Iu�^u�Ju��� ��&    ��    U���,��fh  �E�p�E�p
�}�W��G�����}�W�EP�~����E�8�u���
   �f��� ��&    �U����u�}�F�E��N
�V�ˋF��v�+u�V��f�&f�����Iu�^+u�Ju��� ��&    �v U���,��fh  �E�p�E�p
�}�W�NG�����}�W�EP�~����E�8�u���
   �f��� ��&    �U���   �E���E����P�$_���]��E� �E��E�x�}��E�x�}��E� �E��E�x�}��E�x�}��E�x
�}��E ��-=i  |-h  �� h  �E��E1ҩ   �t��PR���E���`M �E��Ƀ�
�<$�"Z  �Éу�ZX�щ]̋E1ҩ   �t��PR���E���? �E��Ƀ�
�<$��Y  �Éу�ZX)�ʉEȋE �   =i  |-h  �� h  �E��E1ҩ   �t��PR���E���`M �E��Ƀ�
�<$�Y  �Éу�ZX�щ]ԋE1ҩ   �t��PR���E���? �E��Ƀ�
�<$�JY  �Éу�ZX)�ʉEЋE �   =i  |-h  �� h  �E��E1ҩ   �t��PR���E���`M �E��Ƀ�
�<$��X  �Éу�ZX�щ]ċE1ҩ   �t��PR���E���? �E��Ƀ�
�<$�X  �Éу�ZX)�ʉE��E ;  =i  |-h  �� h  �E��E1ҩ   �t��PR���E���`M �E��Ƀ�
�<$�QX  �Éу�ZX�щ]��E1ҩ   �t��PR���E���? �E��Ƀ�
�<$�X  �Éу�ZX)�ʉE��EԉE��EЉE��E�    �E�;E�|t�E�������E�   �E�;E�|t�E�������E�   �E�+E�P�X  �E�E�+E�P��W  �E�E����U�+Uԉ�T� �E���@�U�+UЉ�T� �E��E�;E��   �E����؉E��u�E�E؋E�E��E؅��6�E����U�+Uԉ�T� �E���@�U�+UЉ�T� �E��E�E�E�)E؋E����U�+Uԉ�T� �E���@�U�+UЉ�T� �E��E�;E������ �   �E����؉E��u�E�E؋E�E�E؅��6�E����U�+Uԉ�T� �E���@�U�+UЉ�T� �E��E�E��E�)E؋E����U�+Uԉ�T� �E���@�U�+UЉ�T� �E��E�;E������ �E�xW�$_�}�W�$_���]����E���
�<$�\  �-d� �Ƀ�
�<$�V  ��f�E����E���
�<$��U  �������E��E�x&W�$_�u��u��u��u��&|��P�$_���]����E���
�<$�\  �-d� �Ƀ�
�<$�U  ��f�E����E���
�<$�U  ���E��E�;E�|t�E�������E�   �E�;E�|t�E�������E�   �E�+E�P�U  �E�E�+E�P�{U  �E��E�    f�E��}��E��e��1ɍ5T� ����Ƌ]ԋVU��E������f�]��u��&f�f�}�f�E�fE�s��A;M�r��E�E�f�E�fE�s�E�E�;E��'  �E����؉E��  �E�E؋E�EԋE؅��|   f�E��}��E��e��1ɍ5T� ����Ƌ]ԋVU��E������f�]��u��&f�f�}�f�E�fE�s��A;M�r��E�E�f�E�fE�s�E�E�EЋE�)E�f�E��}��E��e��1ɍ5T� ����Ƌ]ԋVU��E������f�]��u��&f�f�}�f�E�fE�s��A;M�r��E�E�f�E�fE�s�E�E�;E������� �"  �E����؉E��  �E�E؋E�EЋE؅��|   f�E��}��E��e��1ɍ5T� ����Ƌ]ԋVU��E������f�]��u��&f�f�}�f�E�fE�s��A;M�r��E�E�f�E�fE�s�E�E�EԋE�)E�f�E��}��E��e��1ɍ5T� ����Ƌ]ԋVU��E������f�]��u��&f�f�}�f�E�fE�s��A;M�r��E�E�f�E�fE�s�E�E�;E������� �� ��&    U���   �E���E����P�$_���]��E� �E��E�x�}��E�x�}��E� �E��E�x�}��E�x�}��E�x
�}��E ��-=i  |-h  �� h  �E��E1ҩ   �t��PR���E���`M �E��Ƀ�
�<$�Q  �Éу�ZX�щ]̋E1ҩ   �t��PR���E���? �E��Ƀ�
�<$�eQ  �Éу�ZX)�ʉEȋE �   =i  |-h  �� h  �E��E1ҩ   �t��PR���E���`M �E��Ƀ�
�<$�Q  �Éу�ZX�щ]ԋE1ҩ   �t��PR���E���? �E��Ƀ�
�<$��P  �Éу�ZX)�ʉEЋE �   =i  |-h  �� h  �E��E1ҩ   �t��PR���E���`M �E��Ƀ�
�<$�lP  �Éу�ZX�щ]ċE1ҩ   �t��PR���E���? �E��Ƀ�
�<$�/P  �Éу�ZX)�ʉE��E ;  =i  |-h  �� h  �E��E1ҩ   �t��PR���E���`M �E��Ƀ�
�<$��O  �Éу�ZX�щ]��E1ҩ   �t��PR���E���? �E��Ƀ�
�<$�O  �Éу�ZX)�ʉE��EԉE��EЉE��E�    �E�;E�|t�E�������E�   �E�;E�|t�E�������E�   �E�+E�P�O  �E�E�+E�P�rO  �E�E����U�+Uԉ�T� �E���@�U�+UЉ�T� �E��E�;E��   �E����؉E��u�E�E؋E�E��E؅��6�E����U�+Uԉ�T� �E���@�U�+UЉ�T� �E��E�E�E�)E؋E����U�+Uԉ�T� �E���@�U�+UЉ�T� �E��E�;E������ �   �E����؉E��u�E�E؋E�E�E؅��6�E����U�+Uԉ�T� �E���@�U�+UЉ�T� �E��E�E��E�)E؋E����U�+Uԉ�T� �E���@�U�+UЉ�T� �E��E�;E������ �E�xW�$_�}�W�$_���]����E���
�<$�
T  �-d� �Ƀ�
�<$�M  ��f�E����E���
�<$�oM  �������E��E�x&W�$_�u��u��u��u��s��P�$_���]����E���
�<$�S  �-d� �Ƀ�
�<$�M  ��f�E����E���
�<$� M  ���E��E�;E�|t�E�������E�   �E�;E�|t�E�������E�   �E�+E�P�
M  �E�E�+E�P��L  �E��E�    f�E��}��E��e��1ɍ5T� ����Ƌ]ԋVU��E������f�]��u��&f�f;U$tf�}�f�E�fE�s��A;M�r��E�E�f�E�fE�s�E�E�;E��3  �E����؉E��  �E�E؋E�EԋE؅��   f�E��}��E��e��1ɍ5T� ����Ƌ]ԋVU��E������f�]��u��&f�f;U$tf�}�f�E�fE�s��A;M�r��E�E�f�E�fE�s�E�E�EЋE�)E�f�E��}��E��e��1ɍ5T� ����Ƌ]ԋVU��E������f�]��u��&f�f;U$tf�}�f�E�fE�s��A;M�r��E�E�f�E�fE�s�E�E�;E������� �.  �E����؉E��  �E�E؋E�EЋE؅��   f�E��}��E��e��1ɍ5T� ����Ƌ]ԋVU��E������f�]��u��&f�f;U$tf�}�f�E�fE�s��A;M�r��E�E�f�E�fE�s�E�E�EԋE�)E�f�E��}��E��e��1ɍ5T� ����Ƌ]ԋVU��E������f�]��u��&f�f;U$tf�}�f�E�fE�s��A;M�r��E�E�f�E�fE�s�E�E�;E������� �� ��&    ��U��U�u�N�v�}��m�m�ʃ�R����!�1�%������؉E ��������u�Z���� t�����f�E ]�� ��&    ��&    �U���,��fh  �E�p�E�p
�}�W�n5�����}�W�EP�EP�Z����E�8�u���
   �f��� �t& U��U�u�N�v�}��m�m�ʃ�R��%  ��      )؉Á�    ��k�1؋���������������@ @ )ډӁ�@ @ ��k�?1���	Ћ��� � ��� � �������    )ډӁ�    ��k�1���	Ѓ���E ���������\���Z���� t ]�� ��&    ��&    �U���,��