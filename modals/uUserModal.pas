unit uUserModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Memo.Types, FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.ImgList,
  FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Layouts,
  System.Skia, FMX.Skia, FMX.Effects, Data.DB, System.Hash, FMX.Media, FMX.MediaLibrary.Actions, FMX.MediaLibrary;

type
  TfUserModal = class(TFrame)
    lytContentH: TLayout;
    rBackground: TRectangle;
    rModalInfo: TRectangle;
    ScrollBox1: TScrollBox;
    lytUserH: TLayout;
    lytFullName: TLayout;
    lbFullName: TLabel;
    eFullName: TEdit;
    lytTitle: TLayout;
    lbTitle: TLabel;
    btnClose: TSpeedButton;
    lytPatientProfile: TLayout;
    lytProfilePhoto: TLayout;
    lytPhotoButton: TLayout;
    lytPhotoButtonH: TLayout;
    cProfilePhoto: TCircle;
    gIcon: TGlyph;
    lNameH: TLabel;
    btnPhotoUpload: TCornerButton;
    btnCamera: TCornerButton;
    lProfileUploadDesc: TLabel;
    lytEmailAddress: TLayout;
    lEmailAddress: TLabel;
    eEmailAddress: TEdit;
    lProfilePhoto: TLabel;
    lPersonalInfo: TLabel;
    lytContactNumber: TLayout;
    lContactNumber: TLabel;
    eContactNumber: TEdit;
    rUser: TRectangle;
    rRoleAndAccess: TRectangle;
    lytRoleAndAccessH: TLayout;
    lytButtonSaveH: TLayout;
    btnSaveUser: TCornerButton;
    btnCancel: TCornerButton;
    lytRole: TLayout;
    lRole: TLabel;
    cbRole: TComboBox;
    lRoleInput: TLabel;
    lytStatus: TLayout;
    lStatus: TLabel;
    cbStatus: TComboBox;
    lStatusInput: TLabel;
    slRoleAndAccess: TSkLabel;
    lytDepartment: TLayout;
    lDepartment: TLabel;
    eDepartment: TEdit;
    imgProfilePhoto: TImage;
    rImageFrame: TRectangle;
    crFullName: TCalloutRectangle;
    gFullName: TGlyph;
    lFullNameW: TLabel;
    ShadowEffect1: TShadowEffect;
    crEmailAddress: TCalloutRectangle;
    gEmailAddress: TGlyph;
    lEmailAddressW: TLabel;
    ShadowEffect2: TShadowEffect;
    crContactNumber: TCalloutRectangle;
    gContactNumber: TGlyph;
    lContactNumberW: TLabel;
    ShadowEffect3: TShadowEffect;
    lytUsername: TLayout;
    lUserName: TLabel;
    eUsername: TEdit;
    crUsername: TCalloutRectangle;
    gUsername: TGlyph;
    lUsernameW: TLabel;
    ShadowEffect4: TShadowEffect;
    lytPassword: TLayout;
    lPassword: TLabel;
    ePassword: TEdit;
    crPassword: TCalloutRectangle;
    gPassword: TGlyph;
    lPasswordW: TLabel;
    ShadowEffect5: TShadowEffect;
    ccCapturePhoto: TCameraComponent;
    sdSavePicture: TSaveDialog;
    rCameralModal: TRectangle;
    lytImgTools: TLayout;
    lytCameraOption: TLayout;
    lCamera: TLabel;
    cbCameraOption: TComboBox;
    lCameraDesc: TLabel;
    btnSaveCurrentImage: TCornerButton;
    btnTakePicture: TCornerButton;
    lytClosebtn: TLayout;
    btnCameraClose: TSpeedButton;
    lytPaintBox: TLayout;
    imgPhoto: TImage;
    procedure btnCloseClick(Sender: TObject);
    procedure cbRoleChange(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure cbStatusMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure cbRoleMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveUserClick(Sender: TObject);
    procedure btnCameraClick(Sender: TObject);
    procedure ccCapturePhotoSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure btnPhotoUploadClick(Sender: TObject);
    procedure btnTakePictureClick(Sender: TObject);
    procedure btnSaveCurrentImageClick(Sender: TObject);
    procedure btnCameraCloseClick(Sender: TObject);
    procedure cbCameraOptionChange(Sender: TObject);
  private
    FCapturing: Boolean;
    FStatus: Boolean;
    procedure UpdateCameraList;
    procedure ShowCameraFrame;
    { Private declarations }
  public
    RecordStatus: String;
    procedure ClearItems;
    { Public declarations }
  end;

  const
  TARGET_WIDTH  = 320;
  TARGET_HEIGHT = 240;

implementation

{$R *.fmx}

uses uDm, uMain, uGlobal;

{ Clear Fields }
procedure TfUserModal.ClearItems;
begin
  // Fields
  eFullName.Text := '';
  eUsername.Text := '';
  ePassword.Text := '';
  eEmailAddress.Text := '';
  eContactNumber.Text := '';
  cbRole.ItemIndex := 0;
  eDepartment.Text := '';
  cbStatus.ItemIndex := 0;
  imgProfilePhoto.Bitmap := nil; // set image to empty
end;

{ Update Camera list }
procedure TfUserModal.UpdateCameraList;
begin
  cbCameraOption.Clear;
  // FMX currently provides only Default camera selection, but you can fake list
  cbCameraOption.Items.Add('Default Camera');
  cbCameraOption.ItemIndex := 0;
end;

{ Camera live }
procedure TfUserModal.ShowCameraFrame;
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
      imgPhoto.Bitmap.Canvas.DrawBitmap(
        TempBitmap,
        RectF(0, 0, TempBitmap.Width, TempBitmap.Height),
        RectF(0, 0, TARGET_WIDTH, TARGET_HEIGHT),
        1, True);
    finally
      imgPhoto.Bitmap.Canvas.EndScene;
    end;
  finally
    TempBitmap.Free;
  end;
end;

{ Camera button }
procedure TfUserModal.btnCameraClick(Sender: TObject);
begin
  FCapturing := False;
  FStatus := False;
  UpdateCameraList;

  // Adjust lytPaintBox height
  lytPaintBox.Margins.Bottom := 20;
  lytPaintBox.Margins.Left := 70;
  lytPaintBox.Margins.Right := 70;
  lytPaintBox.Margins.Top := 10;

  // Show Capture photo modal
  rCameralModal.Visible := True;

  // Show components
  lytImgTools.Visible := True;

  // Set the current camera used
  lCameraDesc.Text := cbCameraOption.Text;

  if not FCapturing then
  begin
    ccCapturePhoto.Kind := TCameraKind.Default;  // or ckBackCamera
    ccCapturePhoto.Active := True;
    FCapturing := True;
  end
  else
  begin
    ccCapturePhoto.Active := False;
    FCapturing := False;
  end;
end;

{ Upload Photo }
procedure TfUserModal.btnPhotoUploadClick(Sender: TObject);
var
  LOpenDialog: TOpenDialog;
begin
  LOpenDialog := TOpenDialog.Create(Self);
  try
    // Filter for image types
    LOpenDialog.Filter := 'Image Files|*.bmp;*.jpg;*.jpeg;*.png|All Files|*.*';
    LOpenDialog.Title := 'Select a photo to upload';

    if LOpenDialog.Execute then
    begin
      // ✅ Load the selected file into the TImage
      imgProfilePhoto.Bitmap.LoadFromFile(LOpenDialog.FileName);
    end;
  finally
    LOpenDialog.Free;
    rImageFrame.Visible := True;
  end;
end;

{ Take picture }
procedure TfUserModal.btnTakePictureClick(Sender: TObject);
begin
  if not FStatus then
  begin
    btnTakePicture.Text := 'Retake photo';
    FStatus := True;

    // Show captured image on the image holder
    imgProfilePhoto.Bitmap.Assign(imgPhoto.Bitmap);

    // Disable the camera component
    ccCapturePhoto.Active := False;

    // Show captured image
    imgProfilePhoto.Visible := True;

    // Hide Icon for no captured image
    gIcon.Visible := False;

    // Show Image frame
    rImageFrame.Visible := True;
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
            imgProfilePhoto.Bitmap.Assign(imgPhoto.Bitmap);

            // Disable the camera component
            ccCapturePhoto.Active := False;
          end);
      end).Start;
  end;
end;

{ Save current image }
procedure TfUserModal.btnSaveCurrentImageClick(Sender: TObject);
begin
  if (imgPhoto.Bitmap <> nil) and not imgPhoto.Bitmap.IsEmpty then
  begin
    sdSavePicture.Filter := 'PNG Image|*.png|JPEG Image|*.jpg|Bitmap Image|*.bmp';
    sdSavePicture.DefaultExt := 'png';
    sdSavePicture.FileName := 'CapturedImage.png';

    if sdSavePicture.Execute then
    begin
      imgPhoto.Bitmap.SaveToFile(sdSavePicture.FileName);
      ShowMessage('Image saved to: ' + sdSavePicture.FileName);
    end;
  end
  else
    ShowMessage('No image to save.');
end;

{ Close Camera }
procedure TfUserModal.btnCameraCloseClick(Sender: TObject);
begin
  rCameralModal.Visible := False;
  ccCapturePhoto.Active := False;
  FCapturing := False;
end;

{ Cancel Button }
procedure TfUserModal.btnCancelClick(Sender: TObject);
begin
  Self.Visible := False;
end;

{ Close Button }
procedure TfUserModal.btnCloseClick(Sender: TObject);
begin
  Self.Visible := False;
end;

{ Create User }
procedure TfUserModal.btnSaveUserClick(Sender: TObject);
var
  ms: TMemoryStream;
  HasError: Boolean;
  FirstInvalidPos: Single;
  HashedPassword: string;
begin
  HasError := False;
  FirstInvalidPos := -1;

  // FullName validation
  if eFullName.Text = '' then
  begin
    AdjustLayoutHeight(lytFullname, 95);
    crFullName.Visible := True;
    if FirstInvalidPos = -1 then
      FirstInvalidPos := eFullname.Position.Y;
    HasError := True;
  end
  else
    crFullName.Visible := False;

  // Username validation
  if eUsername.Text = '' then
  begin
    AdjustLayoutHeight(lytUsername, 95);
    crUsername.Visible := True;
    if FirstInvalidPos = -1 then
      FirstInvalidPos := eUsername.Position.Y;
    HasError := True;
  end
  else
    crUsername.Visible := False;

  // Password validation
  if ePassword.Text = '' then
  begin
    AdjustLayoutHeight(lytPassword, 95);
    crPassword.Visible := True;
    if FirstInvalidPos = -1 then
      FirstInvalidPos := ePassword.Position.Y;
    HasError := True;
  end
  else
    crPassword.Visible := False;

  // Email validation
  if eEmailAddress.Text = '' then
  begin
    AdjustLayoutHeight(lytEmailAddress, 95);
    crEmailAddress.Visible := True;
    if FirstInvalidPos = -1 then
      FirstInvalidPos := eEmailAddress.Position.Y;
    HasError := True;
  end
  else
    crEmailAddress.Visible := False;

  // Contact Number validation
  if eContactNumber.Text = '' then
  begin
    AdjustLayoutHeight(lytContactNumber, 95);
    crContactNumber.Visible := True;
    if FirstInvalidPos = -1 then
      FirstInvalidPos := eContactNumber.Position.Y;
    HasError := True;
  end
  else
    crContactNumber.Visible := False;

  // Save image to LONGBLOB
  if Assigned(imgProfilePhoto.Bitmap) and not imgProfilePhoto.Bitmap.IsEmpty then
  begin
    ms := TMemoryStream.Create;
    try
      imgProfilePhoto.Bitmap.SaveToStream(ms);
      ms.Position := 0;
      TBlobField(dm.qPatients.FieldByName('profile_pic')).LoadFromStream(ms);
    finally
      ms.Free;
    end;
  end;

  // Stop if any error is found
  if HasError = True then
  begin
    ScrollBox1.ViewportPosition := PointF(0, FirstInvalidPos - 50);
    Exit;
  end;

  // Handle record state
  if RecordStatus = 'Add' then
    dm.qPatients.Append
  else
    dm.qPatients.Edit;

  // Hash the password (SHA256 for better security)
  HashedPassword := THashSHA2.GetHashString(ePassword.Text);

  // Fields to save
  dm.qUsers.FieldByName('name').AsString := eFullName.Text;
  dm.qUsers.FieldByName('username').AsString := eUsername.Text;
  dm.qUsers.FieldByName('password').AsString := HashedPassword;
  dm.qUsers.FieldByName('email_address').AsString := eEmailAddress.Text;
  dm.qUsers.FieldByName('contact_number').AsString := eContactNumber.Text;

  // Save image to LONGBLOB
  if Assigned(imgProfilePhoto.Bitmap) and not imgProfilePhoto.Bitmap.IsEmpty then
  begin
    ms := TMemoryStream.Create;
    try
      imgProfilePhoto.Bitmap.SaveToStream(ms);
      ms.Position := 0;
      TBlobField(dm.qUsers.FieldByName('profile_pic')).LoadFromStream(ms);
    finally
      ms.Free;
    end;
  end;

  dm.qUsers.FieldByName('user_role').AsString := cbRole.Text;
  dm.qUsers.FieldByName('department').AsString := eDepartment.Text;
  dm.qUsers.FieldByName('status').AsString := cbStatus.Text;

  dm.qUsers.Post;
  dm.qUsers.Refresh;
  ClearItems; // Clear fields

  // Set record pop up message
  if RecordStatus = 'Add' then
    frmMain.Tag := 0
  else
    frmMain.Tag := 1;

  frmMain.RecordMessage('User', 'user');

  // Hide patient modal
  Self.Visible := False;
end;

{ Camera option OnChange }
procedure TfUserModal.cbCameraOptionChange(Sender: TObject);
begin
  lCameraDesc.Text := cbCameraOption.Text;
end;

{ Role On Change }
procedure TfUserModal.cbRoleChange(Sender: TObject);
begin
  lRoleInput.Text := cbRole.Text;
end;

{ Prevents Mouse wheel on Role }
procedure TfUserModal.cbRoleMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
begin
  Handled := True; // Prevents the combo box from scrolling
end;

{ Prevents Mouse wheel on Status }
procedure TfUserModal.cbStatusMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
begin
  Handled := True; // Prevents the combo box from scrolling
end;

{ Camera component buffer }
procedure TfUserModal.ccCapturePhotoSampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  TThread.Synchronize(nil, ShowCameraFrame);
end;

{ Frame Resize }
procedure TfUserModal.FrameResize(Sender: TObject);
begin
  // Modal content margins
  if (frmMain.ClientHeight >= 520) AND (frmMain.ClientWidth >= 870) then
  begin
    rModalInfo.Margins.Left := 310;
    rModalInfo.Margins.Right := 310;
    rModalInfo.Margins.Top := 60;
    rModalInfo.Margins.Bottom := 60;
  end;

  if (frmMain.ClientHeight <= 510) AND (frmMain.ClientWidth <= 860) then
  begin
    rModalInfo.Margins.Left := 70;
    rModalInfo.Margins.Right := 70;
    rModalInfo.Margins.Top := 30;
    rModalInfo.Margins.Bottom := 30;
  end;
end;

end.
