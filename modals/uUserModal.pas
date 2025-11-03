unit uUserModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Memo.Types, FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.ImgList,
  FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Layouts,
  System.Skia, FMX.Skia, FMX.Effects, Data.DB, System.Hash, FMX.Media,
  FMX.MediaLibrary.Actions, FMX.DialogService, FMX.MediaLibrary, FireDAC.Stan.Param;

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
    lytDepartment: TLayout;
    lDepartment: TLabel;
    eDepartment: TEdit;
    rSecuritySettings: TRectangle;
    lytDetails1: TLayout;
    slSecuritySettings: TSkLabel;
    lytNewPassword: TLayout;
    lNewPassword: TLabel;
    eNewPassword: TEdit;
    lytChangePassBH: TLayout;
    btnChangePassword: TCornerButton;
    lytConfirmNewPassword: TLayout;
    lConfirmNewPassword: TLabel;
    eConfirmNewPassword: TEdit;
    ShadowEffect6: TShadowEffect;
    ShadowEffect7: TShadowEffect;
    ShadowEffect8: TShadowEffect;
    btnEye2: TButton;
    btnEye3: TButton;
    btnEye1: TButton;
    lytPhotoButtonH: TLayout;
    crNewPassword: TCalloutRectangle;
    gNewPassword: TGlyph;
    lNewPasswordW: TLabel;
    ShadowEffect9: TShadowEffect;
    crConfirmNewPassword: TCalloutRectangle;
    gConfirmNewPassword: TGlyph;
    lConfirmNewPasswordW: TLabel;
    ShadowEffect10: TShadowEffect;
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
    procedure ePasswordEnter(Sender: TObject);
    procedure ePasswordExit(Sender: TObject);
    procedure lytDetails1Resize(Sender: TObject);
    procedure btnChangePasswordClick(Sender: TObject);
    procedure btnEye2Click(Sender: TObject);
    procedure btnEye3Click(Sender: TObject);
    procedure eNewPasswordEnter(Sender: TObject);
    procedure eNewPasswordExit(Sender: TObject);
    procedure eConfirmNewPasswordEnter(Sender: TObject);
    procedure eConfirmNewPasswordExit(Sender: TObject);
    procedure btnEye1Click(Sender: TObject);
    procedure ePasswordChangeTracking(Sender: TObject);
    procedure eNewPasswordChangeTracking(Sender: TObject);
    procedure eConfirmNewPasswordChangeTracking(Sender: TObject);
  private
    FCapturing: Boolean;
    FStatus: Boolean;
    procedure UpdateCameraList;
    procedure ShowCameraFrame;
    procedure EditComponentsResponsive;
    { Private declarations }
  public
    HasError: Boolean;
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
  lytPassword.Visible := True;
  btnEye1.Visible := False;
  btnEye2.Visible := False;
  btnEye3.Visible := False;

  // Hide validation warnings
  crFullName.Visible := False;
  crEmailAddress.Visible := False;
  crContactNumber.Visible := False;
  crUsername.Visible := False;
  crPassword.Visible := False;

  // Hide Change Password Section
  rSecuritySettings.Opacity := 0;
  rSecuritySettings.Height := 0;

  ScrollBox1.ViewportPosition := PointF(0, 0);  // Reset Scrollbox
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

    if cProfilePhoto.Fill.Kind = TBrushKind.Solid then
    begin
      // Profile pic changer
      gIcon.ImageIndex := -1;
      lNameH.Visible := True;
    end;
  end;

  // Reset Profile Icon
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

{ OnChangeTracking Confirm new password }
procedure TfUserModal.eConfirmNewPasswordChangeTracking(Sender: TObject);
begin
  if not (eConfirmNewPassword.Text = '') then
    btnEye3.Visible := True
  else
    btnEye3.Visible := False;
end;

{ OnEnter Confirm new password }
procedure TfUserModal.eConfirmNewPasswordEnter(Sender: TObject);
begin
  if not (eConfirmNewPassword.Text = '') then
    btnEye3.Visible := True
  else
    btnEye3.Visible := False;
end;

{ OnExit Confirm new password }
procedure TfUserModal.eConfirmNewPasswordExit(Sender: TObject);
begin
  if not (eConfirmNewPassword.Text = '') then
    btnEye3.Visible := True
  else
    btnEye3.Visible := False;
end;

{ OnChangeTracking New password }
procedure TfUserModal.eNewPasswordChangeTracking(Sender: TObject);
begin
  if not (eNewPassword.Text = '') then
    btnEye2.Visible := True
  else
    btnEye2.Visible := False;
end;

{ OnEnter New password }
procedure TfUserModal.eNewPasswordEnter(Sender: TObject);
begin
  if not (eNewPassword.Text = '') then
    btnEye2.Visible := True
  else
    btnEye2.Visible := False;
end;

{ OnExit New password }
procedure TfUserModal.eNewPasswordExit(Sender: TObject);
begin
  if not (eNewPassword.Text = '') then
    btnEye2.Visible := True
  else
    btnEye2.Visible := False;
end;

{ OnChangeTracking Password }
procedure TfUserModal.ePasswordChangeTracking(Sender: TObject);
begin
  if not (ePassword.Text = '') then
    btnEye1.Visible := True
  else
    btnEye1.Visible := False;
end;

{ OnEnter Edit Password }
procedure TfUserModal.ePasswordEnter(Sender: TObject);
begin
  if not (ePassword.Text = '') then
    btnEye1.Visible := True
  else
    btnEye1.Visible := False;
end;

{ OnExit Edit Password }
procedure TfUserModal.ePasswordExit(Sender: TObject);
begin
  if not (ePassword.Text = '') then
    btnEye1.Visible := True
  else
    btnEye1.Visible := False;
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
  frmMain.fUserDetails.Visible := False;  // Hide UserDetails modal
end;

{ Change Password Button }
procedure TfUserModal.btnChangePasswordClick(Sender: TObject);
var
  FirstInvalidPos: Single;
  InputUser, InputPassHash: String;
begin
  HasError := False;
  FirstInvalidPos := -1;
  InputUser := Trim(eUsername.Text);

  // New password validation
  if eNewPassword.Text = '' then
  begin
    AdjustLayoutHeight(lytNewPassword, 95);
    crNewPassword.Visible := True;
    if FirstInvalidPos = -1 then
      FirstInvalidPos := eNewPassword.Position.Y;
    HasError := True;
  end
  else
    crNewPassword.Visible := False;

  // Confirm new password validation
  if eConfirmNewPassword.Text = '' then
  begin
    AdjustLayoutHeight(lytConfirmNewPassword, 95);
    crConfirmNewPassword.Visible := True;
    if FirstInvalidPos = -1 then
      FirstInvalidPos := eConfirmNewPassword.Position.Y;
    HasError := True;
  end
  else
    crConfirmNewPassword.Visible := False;

  // Stop if any error is found
  if HasError = True then
  begin
    ScrollBox1.ViewportPosition := PointF(0, FirstInvalidPos - 50);
    dm.qUsers.Cancel;
    Exit;
  end;

  with dm.qTemp do
  begin
    Close;
    SQL.Text :=
      'SELECT username, password FROM users WHERE username = :u AND password = :p';
    ParamByName('u').AsString := InputUser;
    ParamByName('p').AsString := ePassword.Text;
    Open;

    if not IsEmpty then
    begin
      if eNewPassword.Text = eConfirmNewPassword.Text then
      begin
        Edit;
        InputPassHash := THashSHA2.GetHashString(eConfirmNewPassword.Text);
        FieldByName('password').AsString := InputPassHash;
        Post;

        // Record Message
        frmMain.Tag := 12;
        frmMain.RecordMessage('Password', eUsername.Text);
      end
      else
      TDialogService.MessageDialog('New passwords does not match',
        TMsgDlgType.mtError, // info icon
        [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil
        // No callback, so code continues immediately
        )
    end
    else
      TDialogService.MessageDialog('Invalid password.',
        TMsgDlgType.mtError, // info icon
        [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil
        // No callback, so code continues immediately
        );
    Close;
  end;
end;

{ Close Button }
procedure TfUserModal.btnCloseClick(Sender: TObject);
begin
  Self.Visible := False;
end;

{ Password Show Button }
procedure TfUserModal.btnEye1Click(Sender: TObject);
begin
  if ePassword.Password then
  begin
    ePassword.Password := False;
    btnEye1.ImageIndex := 44;
  end
  else
  begin
    ePassword.Password := True;
    btnEye1.ImageIndex := 43;
  end;
end;

{ New password Show Button }
procedure TfUserModal.btnEye2Click(Sender: TObject);
begin
  if eNewPassword.Password then
  begin
    eNewPassword.Password := False;
    btnEye2.ImageIndex := 44;
  end
  else
  begin
    eNewPassword.Password := True;
    btnEye2.ImageIndex := 43;
  end;
end;

{ Confirm new password Show Button }
procedure TfUserModal.btnEye3Click(Sender: TObject);
begin
  if eConfirmNewPassword.Password then
  begin
    eConfirmNewPassword.Password := False;
    btnEye3.ImageIndex := 44;
  end
  else
  begin
    eConfirmNewPassword.Password := True;
    btnEye3.ImageIndex := 43;
  end;
end;

{ Create User }
procedure TfUserModal.btnSaveUserClick(Sender: TObject);
var
  ms: TMemoryStream;
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
  if lytPassword.Visible then
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

  // Handle record state
  if dm.RecordStatus = 'Add' then
  begin
    // Query to check for existing username
    QueryExistingUsername;
    dm.qUsers.Append;
  end
  else
  begin
    dm.qUsers.Edit;
  end;

  // Stop if any error is found
  if HasError = True then
  begin
    ScrollBox1.ViewportPosition := PointF(0, FirstInvalidPos - 50);
    dm.qUsers.Cancel;
    Exit;
  end;

  // Fields to save
  dm.qUsers.FieldByName('name').AsString := eFullName.Text;
  dm.qUsers.FieldByName('username').AsString := eUsername.Text;

  // Hash the password (SHA256 for better security)
  if dm.RecordStatus = 'Add' then
  begin
    HashedPassword := THashSHA2.GetHashString(ePassword.Text);
    dm.qUsers.FieldByName('password').AsString := HashedPassword;
  end;

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

  // Set record pop up message
  if dm.FormReader = 'Main' then
  begin
    if dm.RecordStatus = 'Add' then
      frmMain.Tag := 6
    else
      frmMain.Tag := 7;

    frmMain.RecordMessage('User', eUsername.Text);
    Self.Visible := False;  // Hide patient modal
  end
  else
  begin
    // Creating first admin
    // Message dialog with success icon - Successfully completed admin setup
    TDialogService.MessageDialog(
      'Successfully completed admin setup. You can now proceed to login',
      TMsgDlgType.mtConfirmation,  // info icon
      [TMsgDlgBtn.mbOK],
      TMsgDlgBtn.mbOK, 0,
      nil  // No callback, so code continues immediately
    );

    frmAdminSetup.Close;
    frmAdminSetup := nil;
    Self.Visible := False;  // Hide patient modal
  end;
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
  EditComponentsResponsive;

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
      rModalInfo.Margins.Left := 450;
      rModalInfo.Margins.Right := 450;
      rModalInfo.Margins.Top := 75;
      rModalInfo.Margins.Bottom := 75;
    end
    else if (frmMain.ClientWidth <= 850) then
    begin
      rModalInfo.Margins.Left := 190;
      rModalInfo.Margins.Right := 190;
      rModalInfo.Margins.Top := 50;
      rModalInfo.Margins.Bottom := 50;
    end;
  end;
end;

{ Layout Responsiveness adjuster }
procedure TfUserModal.EditComponentsResponsive;
begin
  lytNewPassword.Width := Trunc(lytDetails1.Width / 2) - 8; // -8 to account for spacing
  lytConfirmNewPassword.Width := Trunc(lytDetails1.Width / 2) - 8;
end;

{ Details 1 responsive }
procedure TfUserModal.lytDetails1Resize(Sender: TObject);
begin
  EditComponentsResponsive;
end;

end.
