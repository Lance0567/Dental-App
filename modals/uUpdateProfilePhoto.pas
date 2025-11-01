unit uUpdateProfilePhoto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.Media, FMX.ListBox,
  FMX.MediaLibrary, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, FMX.DialogService, System.DateUtils, FMX.Effects,
  FMX.ImgList, Data.DB, FireDAC.Stan.Param;

type
  TfUpdateProfilePhoto = class(TFrame)
    lytContentH: TLayout;
    rBackground: TRectangle;
    rModalInfo: TRectangle;
    lytTitle: TLayout;
    lbTitle: TLabel;
    btnClose: TSpeedButton;
    lytPatientProfile: TLayout;
    lytProfilePhoto: TLayout;
    cProfilePhoto: TCircle;
    lNameH: TLabel;
    lytPhotoButton: TLayout;
    lytPhotoButtonH: TLayout;
    btnPhotoUpload: TCornerButton;
    btnCamera: TCornerButton;
    cbRemove: TCornerButton;
    lProfileUploadDesc: TLabel;
    ccCapturePhoto: TCameraComponent;
    sdSavePicture: TSaveDialog;
    rCameralModal: TRectangle;
    lytImgTools: TLayout;
    lytCameraOption: TLayout;
    lCamera: TLabel;
    cbCameraOption: TComboBox;
    btnSaveCurrentImage: TCornerButton;
    btnTakePicture: TCornerButton;
    lytClosebtn: TLayout;
    btnCameraClose: TSpeedButton;
    lPreviewImage: TLabel;
    lytPaintBox: TLayout;
    imgPhoto: TImage;
    gIcon: TGlyph;
    procedure btnCameraClick(Sender: TObject);
    procedure ccCapturePhotoSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure btnCameraCloseClick(Sender: TObject);
    procedure btnTakePictureClick(Sender: TObject);
    procedure btnPhotoUploadClick(Sender: TObject);
    procedure cbRemoveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    FCapturing: Boolean;
    FStatus: Boolean;
    procedure UpdateCameraList;
    procedure ShowCameraFrame;
    { Private declarations }
  public
    { Public declarations }
  end;

const
  TARGET_WIDTH = 320;
  TARGET_HEIGHT = 240;

implementation

{$R *.fmx}

uses uMain, uDm, uUserProfile;

{ Camera option list }
procedure TfUpdateProfilePhoto.UpdateCameraList;
begin
  cbCameraOption.Clear;
  // FMX currently provides only Default camera selection, but you can fake list
  cbCameraOption.Items.Add('Default Camera');
  cbCameraOption.ItemIndex := 0;
end;

{ Close Camera modal }
procedure TfUpdateProfilePhoto.btnCameraCloseClick(Sender: TObject);
begin
  rCameralModal.Visible := False;
  ccCapturePhoto.Active := False;
  FCapturing := False
end;

{ Close button }
procedure TfUpdateProfilePhoto.btnCloseClick(Sender: TObject);
begin
  Self.Visible := False;
end;

{ Upload Button }
procedure TfUpdateProfilePhoto.btnPhotoUploadClick(Sender: TObject);
var
  LOpenDialog: TOpenDialog;
  ms: TMemoryStream;
begin
  LOpenDialog := TOpenDialog.Create(Self);
  try
    // Filter for image types
    LOpenDialog.Filter := 'Image Files|*.bmp;*.jpg;*.jpeg;*.png|All Files|*.*';
    LOpenDialog.Title := 'Select a photo to upload';

    if LOpenDialog.Execute then
    begin
      // ✅ Load the selected file into the TImage
      cProfilePhoto.Fill.Bitmap.Bitmap.LoadFromFile(LOpenDialog.FileName);
      cProfilePhoto.Fill.Kind := TBrushKind.Bitmap;
      cProfilePhoto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
      cProfilePhoto.Cursor := crHandPoint; // Change cursor
      frmMain.fUserProfile.rUserPhoto.Fill.Bitmap.Bitmap.Assign(cProfilePhoto.Fill.Bitmap.Bitmap);
      frmMain.fUserProfile.fToolbar.rUserImage.Fill.Bitmap.Bitmap.Assign(cProfilePhoto.Fill.Bitmap.Bitmap);

      lNameH.Visible := False; // Hide Name holder
      gIcon.ImageIndex := -1; // Hide Icon

      // Save in database
      with dm do
      begin
        qTemp.Close;
        qTemp.SQL.Text := 'SELECT id, username, profile_pic ' + 'FROM users ' +
          'WHERE id = :u AND username = :p';
        qTemp.ParamByName('u').AsInteger := User.IDH;
        qTemp.ParamByName('p').AsString := User.UsernameH;
        qTemp.Open;
        qTemp.Edit;

        // Save image to LONGBLOB
        if Assigned(cProfilePhoto.Fill.Bitmap.Bitmap) and
          not cProfilePhoto.Fill.Bitmap.Bitmap.IsEmpty then
        begin
          ms := TMemoryStream.Create;
          try
            cProfilePhoto.Fill.Bitmap.Bitmap.SaveToStream(ms);
            ms.Position := 0;
            TBlobField(qTemp.FieldByName('profile_pic')).LoadFromStream(ms);
          finally
            ms.Free;
          end;
        end;
        qTemp.Post;
        qTemp.Refresh;

        // Set record pop up message
        frmMain.Tag := 11;
        frmMain.RecordMessage('Photo', 'profile');
        qTemp.Close;
      end;
    end;
  finally
    LOpenDialog.Free;
  end;
end;

{ Take Picture }
procedure TfUpdateProfilePhoto.btnTakePictureClick(Sender: TObject);
var
  ms: TMemoryStream;
begin
  if not FStatus then
  begin
    btnTakePicture.Text := 'Retake photo'; // Change caption of the button
    FStatus := True; // Camera component status
    ccCapturePhoto.Active := False; // Disable the camera component
    cProfilePhoto.Fill.Bitmap.Bitmap.Assign(imgPhoto.Bitmap);
    // Show captured image on the image holder
  end
  else
  begin
    // Run the camera activation after a 3-second delay in a background thread
    TThread.CreateAnonymousThread(
      procedure
      begin
        ccCapturePhoto.Active := True;
        FCapturing := True;

        // Wait for 1.5 seconds
        TThread.Sleep(1500);

        // Execute the rest of the code on the main UI thread
        TThread.Synchronize(nil,
          procedure
          begin
            // Show captured image on the image holder
            cProfilePhoto.Fill.Bitmap.Bitmap.Assign(imgPhoto.Bitmap);

            // Disable the camera component
            ccCapturePhoto.Active := False;
          end);
      end).Start;
  end;
  cProfilePhoto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
  // Wrapmode set to stretch
  cProfilePhoto.Cursor := crHandPoint; // Change cursor
  lNameH.Visible := False; // Hide Name holder
  frmMain.fUserProfile.rUserPhoto.Fill.Bitmap.Bitmap.Assign(imgPhoto.Bitmap);
  frmMain.fUserProfile.fToolbar.rUserImage.Fill.Bitmap.Bitmap.Assign(imgPhoto.Bitmap);

  // Save in database
  with dm do
  begin
    qTemp.Close;
    qTemp.SQL.Text := 'SELECT id, username, profile_pic ' + 'FROM users ' +
      'WHERE id = :u AND username = :p';
    qTemp.ParamByName('u').AsInteger := User.IDH;
    qTemp.ParamByName('p').AsString := User.UsernameH;
    qTemp.Open;
    qTemp.Edit;

    // Save image to LONGBLOB
    if Assigned(cProfilePhoto.Fill.Bitmap.Bitmap) and
      not cProfilePhoto.Fill.Bitmap.Bitmap.IsEmpty then
    begin
      ms := TMemoryStream.Create;
      try
        cProfilePhoto.Fill.Bitmap.Bitmap.SaveToStream(ms);
        ms.Position := 0;
        TBlobField(qTemp.FieldByName('profile_pic')).LoadFromStream(ms);
      finally
        ms.Free;
      end;
    end;
    qTemp.Post;
    qTemp.Refresh;

    // Set record pop up message
    frmMain.Tag := 11;
    frmMain.RecordMessage('Photo', 'profile');
    qTemp.Close;
  end;
end;

{ Remove Button }
procedure TfUpdateProfilePhoto.cbRemoveClick(Sender: TObject);
begin
  cProfilePhoto.Fill.Kind := TBrushKind.Solid;
  cProfilePhoto.Fill.Bitmap.Bitmap.Clear(TAlphaColorRec.Null);
  gIcon.ImageIndex := 10;
end;

{ Camera live }
procedure TfUpdateProfilePhoto.ccCapturePhotoSampleBufferReady(Sender: TObject;
const ATime: TMediaTime);
begin
  TThread.Synchronize(nil, ShowCameraFrame);
end;

{ Show Camera Frame }
procedure TfUpdateProfilePhoto.ShowCameraFrame;
var
  TempBitmap: TBitmap;
begin
  TempBitmap := TBitmap.Create;
  try
    // Get camera frame into a temporary bitmap
    ccCapturePhoto.SampleBufferToBitmap(TempBitmap, True);

    // Resize to 320x240 for consistent appearance
    imgPhoto.Bitmap.SetSize(TARGET_WIDTH, TARGET_HEIGHT);
    imgPhoto.Bitmap.Clear(TAlphaColors.Black); // Optional: background fill
    imgPhoto.Bitmap.Canvas.BeginScene;
    try
      imgPhoto.Bitmap.Canvas.DrawBitmap(TempBitmap,
        RectF(0, 0, TempBitmap.Width, TempBitmap.Height),
        RectF(0, 0, TARGET_WIDTH, TARGET_HEIGHT), 1, True);
    finally
      imgPhoto.Bitmap.Canvas.EndScene;
    end;
  finally
    TempBitmap.Free;
  end;
end;

{ Camera Button }
procedure TfUpdateProfilePhoto.btnCameraClick(Sender: TObject);
begin
  FCapturing := False;
  FStatus := False;
  UpdateCameraList;

  cProfilePhoto.Fill.Kind := TBrushKind.Bitmap;

  // Adjust lytPaintBox height
  lytPaintBox.Margins.Bottom := 20;
  lytPaintBox.Margins.Left := 70;
  lytPaintBox.Margins.Right := 70;
  lytPaintBox.Margins.Top := 10;

  // Hide label in camera modal
  lPreviewImage.Visible := False;

  // Show Capture photo modal
  rCameralModal.Visible := True;

  // Show components
  lytImgTools.Visible := True;

  if not FCapturing then
  begin
    ccCapturePhoto.Kind := TCameraKind.Default; // or ckBackCamera
    ccCapturePhoto.Active := True;
    FCapturing := True;
  end
  else
  begin
    ccCapturePhoto.Active := False;
    FCapturing := False;
  end;
end;

end.
