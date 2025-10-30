unit uToolbar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, FMX.Controls.Presentation, FMX.Ani, FMX.Objects, FMX.Skia,
  FMX.ImgList, FMX.Layouts, FMX.MultiView, FMX.DialogService, Data.DB;

type
  TfToolbar = class(TFrame)
    rToolbar: TRectangle;
    lBevel: TLine;
    lytToolbarH: TLayout;
    gDateIcon: TGlyph;
    lytUser: TLayout;
    slUserName: TSkLabel;
    rUserImage: TRoundRect;
    rPopUp: TRectangle;
    FloatAnimation4: TFloatAnimation;
    lDate: TLabel;
    mvPopUp: TMultiView;
    cbAccountSettings: TCornerButton;
    cbLogout: TCornerButton;
    lDivider: TLine;
    gIcon: TGlyph;
    lNameH: TLabel;
    procedure cbAccountSettingsClick(Sender: TObject);
    procedure cbLogoutClick(Sender: TObject);
    procedure FramePainting(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    { Private declarations }
  public
    procedure ProfileSetter;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uMain, uLogin, uDm;

{ Set Profile pic }
procedure TfToolbar.ProfileSetter;
var
  ms: TMemoryStream;
begin
  dm.qUsers.Open; // Open users query

  // Get Profile Photo
  // Load Profile Photo (LONGBLOB -> TImage)
  rUserImage.Fill.Kind := TBrushKind.Bitmap;
  ms := TMemoryStream.Create;
  try
    if not dm.qUsers.FieldByName('profile_pic').IsNull then
    begin
      TBlobField(dm.qUsers.FieldByName('profile_pic')).SaveToStream(ms);
      ms.Position := 0;
      rUserImage.Fill.Bitmap.Bitmap.LoadFromStream(ms);
      gIcon.ImageIndex := -1; // Hide Icon
    end
    else
    begin
      rUserImage.Fill.Bitmap.Bitmap := nil; // Clear if no photo
      rUserImage.Fill.Kind := TBrushKind.Solid; // Set color background
      gIcon.ImageIndex := 10; // Show Icon
    end;
  finally
    rUserImage.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    ms.Free;
  end;

  dm.qUsers.Close; // Close users query
end;

{ Account Settings Button }
procedure TfToolbar.cbAccountSettingsClick(Sender: TObject);
begin
  // Hide frames
  frmMain.HideFrames;

  // Reset Button Focus
  frmMain.ButtonPressedReset;
  mvPopUp.HideMaster; // Hide toolbar Popup

  // Switch tab index
  frmMain.tcController.TabIndex := 4;
  frmMain.fUserProfile.tcController.TabIndex := 0;
  frmMain.fUserProfile.rPersonalInfo.Visible := True;
  frmMain.fUserProfile.Visible := True;
  frmMain.fUserProfile.ScrollBox1.ViewportPosition := PointF(0, 0); // reset scrollbox

  // Set fields
  with dm.User do
  begin
    if RoleH = 'Admin' then
    begin
      frmMain.fUserProfile.cbRole.Enabled := True;
      frmMain.fUserProfile.cbRole.ItemIndex := 0;
    end
    else
    begin
      frmMain.fUserProfile.cbRole.Enabled := False;
      frmMain.fUserProfile.cbRole.ItemIndex := 1;    
    end;

    // Populate fields
    frmMain.fUserProfile.eFullName.Text := FullnameH; // Fullname
    frmMain.fUserProfile.lUserNameH.Text := UsernameH;  // Username
    frmMain.fUserProfile.eUserName.Text := UsernameH;  // Username
    frmMain.fUserProfile.lEmailH.Text := EmailH;  // Email
    frmMain.fUserProfile.eEmail.Text := EmailH;  // Email
    frmMain.fUserProfile.ePhoneNumber.Text := PhoneH;  // Phone number
    frmMain.fUserProfile.mBio.Text := BioH;  // Bio
    frmMain.fUserProfile.lbRoleH.Text := RoleH; // Role
  end;

  // Role config
  frmMain.fUserProfile.RoleConfig;

  // User Profile
  if rUserImage.Fill.Kind = TBrushKind.Bitmap then
  begin
    frmMain.fUserProfile.rUserPhoto.Fill.Bitmap.Bitmap.Assign(rUserImage.Fill.Bitmap.Bitmap);
    frmMain.fUserProfile.rUserPhoto.Fill.Kind := TBrushKind.Bitmap;
    frmMain.fUserProfile.rUserPhoto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    frmMain.fUserProfile.lNameH.Visible := False;
    frmMain.fUserProfile.gUserPhoto.ImageIndex := -1;
  end
  else
  begin
    frmMain.fUserProfile.rUserPhoto.Fill.Kind := TBrushKind.Solid;
    frmMain.fUserProfile.lNameH.Visible := True;
    frmMain.fUserProfile.gUserPhoto.ImageIndex := -1;
  end;
end;

{ Logout Button }
procedure TfToolbar.cbLogoutClick(Sender: TObject);
begin
  mvPopUp.HideMaster; // Hide Popup

  TDialogService.MessageDialog('Are you sure you want to logout?',
    TMsgDlgType.mtInformation, // info icon
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], // Yes + Cancel buttons
    TMsgDlgBtn.mbNo, // Default button
    0, // Help context
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        dm.conDental.Connected := False;

        // Show login form first
        if not Assigned(frmLogin) then
          Application.CreateForm(TfrmLogin, frmLogin);
        frmLogin.Show;

        // Then release main form safely
        if Assigned(frmMain) then
        begin
          frmMain.Release;
          frmMain := nil;
        end;
      end;
    end);
end;

{ Frame Painting }
procedure TfToolbar.FramePainting(Sender: TObject; Canvas: TCanvas;
const ARect: TRectF);
begin
  slUserName.Words.Items[0].Text := dm.User.UsernameH + ''; // Set the username
  slUserName.Words.Items[1].Text := dm.User.RoleH; // set the role of the user
end;

end.
