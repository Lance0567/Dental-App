unit uUserProfile;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.ImgList,
  FMX.DateTimeCtrls, FMX.Edit, FMX.TabControl, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo, uToolbar, FMX.Effects, System.Hash, FMX.DialogService, FMX.Ani,
  FireDAC.Stan.Param, Data.DB, FMX.ListBox;

type
  TfUserProfile = class(TFrame)
    lytUserBriefInfo: TLayout;
    lytPersonalInfo: TLayout;
    rPersonalInfo: TRectangle;
    rUserBriefinfo: TRectangle;
    lytUserH: TLayout;
    rUserPhoto: TRoundRect;
    lUserNameH: TLabel;
    lEmailH: TLabel;
    rRole: TRectangle;
    lbRoleH: TLabel;
    gRoleIcon: TGlyph;
    lDivider: TLine;
    sbProfile: TSpeedButton;
    sbSettings: TSpeedButton;
    lytHeader: TLayout;
    lbTitle: TLabel;
    lytDetails1: TLayout;
    lytFullName: TLayout;
    lbFullName: TLabel;
    eFullName: TEdit;
    lytUsername: TLayout;
    lUsername: TLabel;
    lytBio: TLayout;
    eUserName: TEdit;
    lBio: TLabel;
    lytPhoneNumber: TLayout;
    ePhoneNumber: TEdit;
    lPhone: TLabel;
    ScrollBox1: TScrollBox;
    lytMyAccount: TLayout;
    lFrameDesc: TLabel;
    lFrameTitle: TLabel;
    lytContent: TLayout;
    gUserPhoto: TGlyph;
    tcController: TTabControl;
    tiProfile: TTabItem;
    tiSettings: TTabItem;
    rSecuritySettings: TRectangle;
    lytHeader2: TLayout;
    lTitle2: TLabel;
    lytCurrentPassword: TLayout;
    eCurrentPassword: TEdit;
    lbCurrentPassowrd: TLabel;
    lytDetails3: TLayout;
    lytNewPassword: TLayout;
    lNewPassword: TLabel;
    eNewPassword: TEdit;
    lytConfirmNewPassword: TLayout;
    lConfirmNewPassword: TLabel;
    eConfirmNewPassword: TEdit;
    lytButton2: TLayout;
    btnChangePassword: TCornerButton;
    gPersonalInfo: TGlyph;
    gSecurityPassword: TGlyph;
    lytButton: TLayout;
    btnSaveProfile: TCornerButton;
    mBio: TMemo;
    cCamera: TCircle;
    gCamera: TGlyph;
    fToolbar: TfToolbar;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    ShadowEffect3: TShadowEffect;
    lNameH: TLabel;
    FloatAnimation1: TFloatAnimation;
    lytEmail: TLayout;
    eEmail: TEdit;
    lEmail: TLabel;
    lytDetails2: TLayout;
    lytRole: TLayout;
    lRole: TLabel;
    cbRole: TComboBox;
    crFullName: TCalloutRectangle;
    gFullName: TGlyph;
    lFullNameW: TLabel;
    ShadowEffect4: TShadowEffect;
    crUsername: TCalloutRectangle;
    gUsername: TGlyph;
    lUsernameW: TLabel;
    ShadowEffect5: TShadowEffect;
    crPhoneNumber: TCalloutRectangle;
    gPhoneNumber: TGlyph;
    lPhoneNumberW: TLabel;
    ShadowEffect6: TShadowEffect;
    crEmail: TCalloutRectangle;
    gEmail: TGlyph;
    lEmailW: TLabel;
    ShadowEffect7: TShadowEffect;
    procedure FrameResize(Sender: TObject);
    procedure lytDetails1Resize(Sender: TObject);
    procedure rUserPhotoPainting(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure btnChangePasswordClick(Sender: TObject);
    procedure cCameraClick(Sender: TObject);
    procedure sbProfileClick(Sender: TObject);
    procedure sbSettingsClick(Sender: TObject);
    procedure btnSaveProfileClick(Sender: TObject);
    procedure cbRoleChange(Sender: TObject);
    procedure tcControllerChange(Sender: TObject);
  private
    procedure HideTabs;
    { Private declarations }
  public
    procedure EditComponentsResponsive;
    procedure RoleConfig;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm, uMain;

{ Change Password Button }
procedure TfUserProfile.btnChangePasswordClick(Sender: TObject);
var
  InputUser, InputPass, InputPassHash: String;
begin
  InputUser := Trim(eUserName.Text);
  InputPass := eCurrentPassword.Text; // Do NOT trim passwords!
  InputPassHash := THashSHA2.GetHashString(InputPass);

  with dm.qTemp do
  begin
    Close;
    SQL.Text :=
      'SELECT username, password FROM users WHERE username = :u AND password = :p';
    ParamByName('u').AsString := InputUser;
    ParamByName('p').AsString := InputPassHash;
    Open;
    if not IsEmpty then
    begin
      if eNewPassword.Text = eConfirmNewPassword.Text then
      begin
        Edit;
        InputPassHash := THashSHA2.GetHashString(eConfirmNewPassword.Text);
        FieldByName('password').AsString := InputPassHash;
        Post;

        // Record message
        frmMain.Tag := 10;
        frmMain.RecordMessage('Password', 'password');
      end
      else
        TDialogService.MessageDialog('New passwords does not match',
        TMsgDlgType.mtError, // info icon
        [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil
        // No callback, so code continues immediately
        )
    end
    else if eCurrentPassword.Text.IsEmpty then
      TDialogService.MessageDialog('Please input your current password.',
        TMsgDlgType.mtError, // info icon
        [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil
        // No callback, so code continues immediately
        )
    else
      TDialogService.MessageDialog('Invalid password.',
        TMsgDlgType.mtError, // info icon
        [TMsgDlgBtn.mbOK], TMsgDlgBtn.mbOK, 0, nil
        // No callback, so code continues immediately
        );
      Close;
  end;
end;

{ Save Profile Button }
procedure TfUserProfile.btnSaveProfileClick(Sender: TObject);
var
  InputUser: String;
  InputID: Integer;
  HasError: Boolean;
  ms: TMemoryStream;
begin
  InputUser := dm.User.UsernameH;
  InputID := dm.User.IDH;
  HasError := False; // Default value

  // Fullname validation
  if eFullName.Text = '' then
  begin
    crFullName.Visible := True;
    HasError := True;
  end
  else
    crFullName.Visible := False;

  // Username validation
  if eUserName.Text = '' then
  begin
    crUsername.Visible := True;
    HasError := True;
  end
  else
    crUsername.Visible := False;

  // Phone number validation
  if ePhoneNumber.Text = '' then
  begin
    crPhoneNumber.Visible := True;
    HasError := True;
  end
  else
    crPhoneNumber.Visible := False;

  // Email validation
  if eEmail.Text = '' then
  begin
    crEmail.Visible := True;
    HasError := True;
  end
  else
    crEmail.Visible := False;

  // Warning for downgrading role
  if (lbRoleH.Text = 'Admin') AND (cbRole.ItemIndex = 1) then
  begin
    TDialogService.MessageDialog
      ('Only Admin can change roles! Are you sure you want to downgrade?',
      TMsgDlgType.mtWarning, // warning icon
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], // Yes + No buttons
      TMsgDlgBtn.mbNo, // Default button is No
      0, // Help context
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrNo then
        begin
          HasError := True;
        end;
      end);
  end;

  // Stop if any error is found
  if HasError then
  begin
    Exit
  end;

  with dm do
  begin
    qTemp.Close;
    qTemp.SQL.Text :=
      'SELECT id, name, username, email_address, contact_number, user_role, bio, profile_pic '
      + 'FROM users ' + 'WHERE id = :u AND username = :p';
    qTemp.ParamByName('u').AsInteger := InputID;
    qTemp.ParamByName('p').AsString := InputUser;
    qTemp.Open;

    if not qTemp.IsEmpty then
    begin
      qTemp.Edit;
      // Fields to save in database
      qTemp.FieldByName('name').AsString := eFullName.Text;
      qTemp.FieldByName('username').AsString := eUserName.Text;
      qTemp.FieldByName('contact_number').AsString := ePhoneNumber.Text;
      qTemp.FieldByName('user_role').AsString := cbRole.Text;
      qTemp.FieldByName('email_address').AsString := eEmail.Text;
      qTemp.FieldByName('bio').AsString := mBio.Text;

      // Save image to LONGBLOB
      if Assigned(rUserPhoto.Fill.Bitmap.Bitmap) and
        not rUserPhoto.Fill.Bitmap.Bitmap.IsEmpty then
      begin
        ms := TMemoryStream.Create;
        try
          rUserPhoto.Fill.Bitmap.Bitmap.SaveToStream(ms);
          ms.Position := 0;
          TBlobField(qTemp.FieldByName('profile_pic')).LoadFromStream(ms);
        finally
          ms.Free;
        end;
      end;
      qTemp.Post;
      qTemp.Refresh;

      // Set record pop up message
      frmMain.Tag := 9;
      frmMain.RecordMessage('Profile', 'profile');
    end;
    qTemp.Close;

    // Fields to save data module
    User.FullnameH := eFullName.Text; // Fullname
    User.UsernameH := eUsername.Text; // Username
    User.EmailH := eEmail.Text; // Email
    User.PhoneH := ePhoneNumber.Text; // Phone number
    User.BioH := mBio.Text; // Bio
    User.RoleH := cbRole.Text; // Role

    // User Profile in Toolbar
    if rUserPhoto.Fill.Kind = TBrushKind.Bitmap then
    begin
      fToolbar.rUserImage.Fill.Bitmap.Bitmap.Assign(rUserPhoto.Fill.Bitmap.Bitmap);
      fToolbar.rUserImage.Fill.Kind := TBrushKind.Bitmap;
      fToolbar.rUserImage.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
      fToolbar.lNameH.Visible := False;
      fToolbar.gIcon.ImageIndex := -1;
    end
    else
    begin
      fToolbar.rUserImage.Fill.Kind := TBrushKind.Solid;
      fToolbar.lNameH.Visible := False;
      fToolbar.gIcon.ImageIndex := -1;
    end;

    // Set account info
    fToolbar.slUserName.Words.Items[0].Text := User.UsernameH + '';
    fToolbar.slUserName.Words.Items[0].Text := User.RoleH;
    lUserNameH.Text := User.UsernameH;
    lEmailH.Text := User.EmailH;
    lbRoleH.Text := User.RoleH;
    RoleConfig; // Status role config
  end;
end;

{ Role Config }
procedure TfUserProfile.RoleConfig;
begin
  if lbRoleH.Text = 'Admin' then
  begin
    rRole.Margins.Left := 45;
    rRole.Margins.Right := 40;
    rRole.Fill.Color := $FEF3E8FF;
    lbRoleH.TextSettings.FontColor := $FE6B21A8;
    gRoleIcon.ImageIndex := 13;
  end
  else
  begin
    rRole.Margins.Left := 25;
    rRole.Margins.Right := 25;
    rRole.Fill.Color := $FEDBEAFE;
    lbRoleH.TextSettings.FontColor := $FF1B4DF3;
    gRoleIcon.ImageIndex := 13;
  end;
end;

{ Role OnChange }
procedure TfUserProfile.cbRoleChange(Sender: TObject);
begin
  RoleConfig;
end;

{ Camera Button }
procedure TfUserProfile.cCameraClick(Sender: TObject);
begin
  // sample
end;

{ Layout Responsiveness adjuster }
procedure TfUserProfile.EditComponentsResponsive;
begin
  lytFullName.Width := Trunc(lytDetails1.Width / 2) - 5;
  // -5 to account for spacing
  lytUsername.Width := Trunc(lytDetails1.Width / 2) - 5;
  lytPhoneNumber.Width := Trunc(lytDetails2.Width / 2) - 5;
  lytRole.Width := Trunc(lytDetails2.Width / 2) - 5;
  lytNewPassword.Width := Trunc(lytDetails3.Width / 2) - 5;
  lytConfirmNewPassword.Width := Trunc(lytDetails3.Width / 2) - 5;
end;

{ Frame Resize }
procedure TfUserProfile.FrameResize(Sender: TObject);
begin
  EditComponentsResponsive;

  if (frmMain.ClientWidth >= 1920) then
  begin
    lytContent.Margins.Left := 290;
    lytContent.Margins.Right := 290;
    lytContent.Margins.Top := 20;
    lytContent.Margins.Bottom := 20;
  end
  else if (frmMain.ClientWidth >= 1366) then
  begin
    lytContent.Margins.Left := 130;
    lytContent.Margins.Right := 130;
    lytContent.Margins.Top := 10;
    lytContent.Margins.Bottom := 10;
  end
  else if (frmMain.ClientHeight <= 510) AND (frmMain.ClientWidth <= 860) then
  begin
    lytContent.Margins.Left := 30;
    lytContent.Margins.Right := 30;
    lytContent.Margins.Top := 10;
    lytContent.Margins.Bottom := 10;
  end;

  // Role resize
  RoleConfig;
end;

{ Details1 OnResize }
procedure TfUserProfile.lytDetails1Resize(Sender: TObject);
begin
  EditComponentsResponsive;
end;

{ User Profile OnPainting }
procedure TfUserProfile.rUserPhotoPainting(Sender: TObject; Canvas: TCanvas;
const ARect: TRectF);
begin
  if fToolbar.rUserImage.Fill.Kind = TBrushKind.Bitmap then
  begin
    rUserPhoto.Fill.Kind := TBrushKind.Bitmap;
    rUserPhoto.Fill.Bitmap.Bitmap.Assign
      (fToolbar.rUserImage.Fill.Bitmap.Bitmap);
    rUserPhoto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    gUserPhoto.Visible := False; // Hide Icon
    lNameH.Visible := False; // Hide Name holder
  end
  else
  begin
    rUserPhoto.Fill.Kind := TBrushKind.Solid;
    gUserPhoto.Visible := False; // Hide Icon
    lNameH.Visible := True; // Show Name older
  end;
end;

{ Hide Tabs }
procedure TfUserProfile.HideTabs;
begin
  rPersonalInfo.Visible := False;
  rSecuritySettings.Visible := False;
end;

{ Profile Button }
procedure TfUserProfile.sbProfileClick(Sender: TObject);
begin
  HideTabs; // Hide Tabs

  // Switch tab
  tcController.TabIndex := 0;
  rPersonalInfo.Visible := True;
end;

{ Settings Button }
procedure TfUserProfile.sbSettingsClick(Sender: TObject);
begin
  HideTabs; // Hide Tabs

  // Switch tab
  tcController.TabIndex := 1;
  rSecuritySettings.Visible := True;

  // Clear password
  eCurrentPassword.Text := '';
  eNewPassword.Text := '';
  eConfirmNewPassword.Text := '';
end;

{ OnChange Tab control }
procedure TfUserProfile.tcControllerChange(Sender: TObject);
begin
  // Change database connection according to the selected tab
  case tcController.TabIndex of
    0:
      begin
        tcController.Height := 560;
      end;
    1:
      begin
        tcController.Height := 350;
      end;
  end;
end;

end.
