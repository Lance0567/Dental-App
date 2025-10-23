unit uUserModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Memo.Types, FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.ImgList,
  FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Layouts,
  System.Skia, FMX.Skia, FMX.Effects, Data.DB, System.Hash, FMX.Media,
  FMX.MediaLibrary.Actions, FMX.DialogService, FMX.MediaLibrary;

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
    lytRole: TLayout;
    lRole: TLabel;
    cbRole: TComboBox;
    lytStatus: TLayout;
    lStatus: TLabel;
    cbStatus: TComboBox;
    slRoleAndAccess: TSkLabel;
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
    btnSaveCurrentImage: TCornerButton;
    btnTakePicture: TCornerButton;
    lytClosebtn: TLayout;
    btnCameraClose: TSpeedButton;
    lytPaintBox: TLayout;
    imgPhoto: TImage;
    lytButtonSaveH: TLayout;
    btnSaveUser: TCornerButton;
    btnCancel: TCornerButton;
    cbShowPassword: TCheckBox;
    lytDepartment: TLayout;
    lDepartment: TLabel;
    eDepartment: TEdit;
    procedure btnCloseClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveUserClick(Sender: TObject);
    procedure btnCameraClick(Sender: TObject);
    procedure ccCapturePhotoSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure btnPhotoUploadClick(Sender: TObject);
    procedure btnTakePictureClick(Sender: TObject);
    procedure btnSaveCurrentImageClick(Sender: TObject);
    procedure btnCameraCloseClick(Sender: TObject);
    procedure eFullNameChangeTracking(Sender: TObject);
    procedure cbShowPasswordChange(Sender: TObject);
    procedure cProfilePhotoPainting(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure ePasswordClick(Sender: TObject);
    procedure ePasswordEnter(Sender: TObject);
    procedure ePasswordExit(Sender: TObject);
  private
    FCapturing: Boolean;
    FStatus: Boolean;
    procedure UpdateCameraList;
    procedure ShowCameraFrame;
    { Private declarations }
  public

    procedure ClearItems;
    { Public declarations }
  end;

  const
  TARGET_WIDTH  = 320;
  TARGET_HEIGHT = 240;

implementation

{$R *.fmx}

uses uDm, uMain, uGlobal, uAdminSetup;

{ Clear Fields }
procedure TfUserModal.ClearItems;
begin
  // Fields
  cProfilePhoto.Fill.Bitmap.Bitmap := nil; // set image to empty
  gIcon.ImageIndex := 10;
  eFullName.Text := '';
  eUsername.ReadOnly := False;
  eUsername.Text := '';
  ePassword.Text := '';
  ePassword.TextPrompt := 'Enter password';
  eEmailAddress.Text := '';
  eContactNumber.Text := '';
  cbRole.ItemIndex := 0;
  eDepartment.Text := '';
  cbStatus.ItemIndex := 0;

  // Hide validation warnings
  crFullName.Visible := False;
  crEmailAddress.Visible := False;
  crContactNumber.Visible := False;
  crUsername.Visible := False;
  crPassword.Visible := False;

  ScrollBox1.ViewportPosition := PointF(0, 0);  // Reset Scrollbox
end;

{ Profile Changer }
procedure TfUserModal.cProfilePhotoPainting(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  if cProfilePhoto.Fill.Kind = TBrushKind.Bitmap then
    lNameH.Visible := False
  else if (not gIcon.ImageIndex = 10 ) AND (cProfilePhoto.Fill.Kind = TBrushKind.Solid) then
    lNameH.Visible := True;
end;

{ Full name OnChange Tracking }
procedure TfUserModal.eFullNameChangeTracking(Sender: TObject);
var
  Parts: TArray<string>;
  Initials: string;
begin
  // Getter of first letter of the Full name
  if eFullName.Text.Trim <> '' then
  begin
    Parts := eFullName.Text.Trim.Split([' ']); // split by space
    Initials := '';

    // First letter of first word
    if Length(Parts) >= 1 then
      Initials := Initials + UpperCase(Parts[0][1]);

    // First letter of second word
    if Length(Parts) >= 2 then
      Initials := Initials + UpperCase(Parts[1][1]);

    lNameH.Text := Initials;

    // Profile pic changer
    gIcon.ImageIndex := -1;
    lNameH.Visible := True;
  end;


  if (eFullName.Text.Trim = '') AND (cProfilePhoto.Fill.Kind = TBrushKind.Solid) then
  begin
    lNameH.Text := '';
    gIcon.ImageIndex := 10;
    lNameH.Visible := False;

    // Style setter
    eFullName.StyledSettings := [TStyledSetting.Style]
  end
  else
    eFullName.StyledSettings := [];

  // Fullname warning reset
  crFullName.Visible := False;
end;

{ On click Password }
procedure TfUserModal.ePasswordClick(Sender: TObject);
begin
  if dm.User.RoleH = 'Admin' then  // if Admin
  begin
    ePassword.Text := '';
    ePassword.TextPrompt := 'Enter new password';
  end
  else
    ShowMessage('Only an Admin can change password');
end;

{ OnEnter Edit Password }
procedure TfUserModal.ePasswordEnter(Sender: TObject);
begin
  cbShowPassword.Visible := True;
end;

{ OnExit Edit Password }
procedure TfUserModal.ePasswordExit(Sender: TObject);
begin
  cbShowPassword.Visible := False;
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
      cProfilePhoto.Fill.Bitmap.Bitmap.LoadFromFile(LOpenDialog.FileName);
      cProfilePhoto.Fill.Kind := TBrushKind.Bitmap;
      cProfilePhoto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
      cProfilePhoto.Cursor := crHandPoint;  // Change cursor

      lNameH.Visible := False;  // Hide Name holder
      gIcon.ImageIndex := -1; // Hide Icon
    end;
  finally
    LOpenDialog.Free;
  end;
end;

{ Take picture }
procedure TfUserModal.btnTakePictureClick(Sender: TObject);
begin
  if not FStatus then
  begin
    btnTakePicture.Text := 'Retake photo';  // Change caption of the button
    FStatus := True;  // Camera status
    ccCapturePhoto.Active := False; // Disable the camera component
    cProfilePhoto.Fill.Bitmap.Bitmap.Assign(imgPhoto.Bitmap); // Show captured image on the image holder
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
  cProfilePhoto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;  // Wrapmode set to stretch
  cProfilePhoto.Cursor := crHandPoint;  // Change cursor
  gIcon.ImageIndex := -1; // Hide Icon
  lNameH.Visible := False;  // Hide Name holder
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
  HashedPassword: String;
  DateCreated: String;
begin
  HasError := False;
  FirstInvalidPos := -1;
  DateCreated := FormatDateTime('mmmm dd, yyyy', Date);

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

  // Stop if any error is found
  if HasError = True then
  begin
    ScrollBox1.ViewportPosition := PointF(0, FirstInvalidPos - 50);
    Exit;
  end;

  // Handle record state
  if dm.RecordStatus = 'Add' then
    dm.qUsers.Append
  else
    dm.qUsers.Edit;

  // Hash the password (SHA256 for better security)
  HashedPassword := THashSHA2.GetHashString(ePassword.Text);

  // Fields to save
  dm.qUsers.FieldByName('name').AsString := eFullName.Text;
  dm.qUsers.FieldByName('username').AsString := eUsername.Text;
  dm.qUsers.FieldByName('password').AsString := HashedPassword;
  dm.qUsers.FieldByName('email_address').AsString := eEmailAddress.Text;
  dm.qUsers.FieldByName('contact_number').AsString := eContactNumber.Text;

  // Save image to LONGBLOB
  if Assigned(cProfilePhoto.Fill.Bitmap.Bitmap) and not cProfilePhoto.Fill.Bitmap.Bitmap.IsEmpty then
  begin
    ms := TMemoryStream.Create;
    try
      cProfilePhoto.Fill.Bitmap.Bitmap.SaveToStream(ms);
      ms.Position := 0;
      TBlobField(dm.qUsers.FieldByName('profile_pic')).LoadFromStream(ms);
    finally
      ms.Free;
    end;
  end;

  dm.qUsers.FieldByName('user_role').AsString := cbRole.Text;
  dm.qUsers.FieldByName('department').AsString := eDepartment.Text;
  dm.qUsers.FieldByName('status').AsString := cbStatus.Text;
  dm.qUsers.FieldByName('date_created').AsString := DateCreated;
  dm.qUsers.FieldByName('last_login').AsString := 'Never logged in';

  dm.qUsers.Post;
  dm.qUsers.Refresh;
  ClearItems; // Clear fields

  // Set record pop up message
  if (dm.FormReader = 'Main') then
  begin
    if dm.RecordStatus = 'Add' then
      frmMain.Tag := 0
    else
      frmMain.Tag := 1;

    frmMain.RecordMessage('User', 'user');
  end
  else
  begin
    // Message dialog with success icon - Successfully completed admin setup
    TDialogService.MessageDialog(
        'Successfully completed admin setup. You can now proceed to login',
        TMsgDlgType.mtConfirmation,  // info icon
        [TMsgDlgBtn.mbOK],
        TMsgDlgBtn.mbOK, 0,
        nil  // No callback, so code continues immediately
      );

    frmAdminSetup.Close;
    frmAdminSetup := nil
  end;

  // Hide patient modal
  Self.Visible := False;
end;

{ Camera component buffer }
procedure TfUserModal.cbShowPasswordChange(Sender: TObject);
begin
  if cbShowPassword.IsChecked then
    ePassword.Password := False
  else
    ePassword.Password := True;
end;

procedure TfUserModal.ccCapturePhotoSampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  TThread.Synchronize(nil, ShowCameraFrame);
end;

{ Frame Resize }
procedure TfUserModal.FrameResize(Sender: TObject);
begin
  if dm.FormReader = 'Main' then
  begin
    // Modal content margins
    if (frmMain.ClientWidth >= 1920) then
    begin
      rModalInfo.Margins.Left := 700;
      rModalInfo.Margins.Right := 700;
      rModalInfo.Margins.Top := 150;
      rModalInfo.Margins.Bottom := 150;
    end
    else if (frmMain.ClientWidth >= 1366) then
    begin
      rModalInfo.Margins.Left := 430;
      rModalInfo.Margins.Right := 430;
      rModalInfo.Margins.Top := 75;
      rModalInfo.Margins.Bottom := 75;
    end
    else if (frmMain.ClientHeight <= 510) AND (frmMain.ClientWidth <= 860) then
    begin
      rModalInfo.Margins.Left := 190;
      rModalInfo.Margins.Right := 190;
      rModalInfo.Margins.Top := 50;
      rModalInfo.Margins.Bottom := 50;
    end;
  end;
end;

end.
