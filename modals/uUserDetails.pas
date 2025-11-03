unit uUserDetails;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, FMX.ListBox, FMX.Skia, FMX.ImgList, FMX.Objects, FMX.Edit,
  FMX.Controls.Presentation, FMX.Layouts, Data.DB, FMX.DialogService, System.Hash;

type
  TfUserDetails = class(TFrame)
    lytContentH: TLayout;
    rBackground: TRectangle;
    rModalInfo: TRectangle;
    ScrollBox1: TScrollBox;
    lytTitle: TLayout;
    lbTitle: TLabel;
    btnClose: TSpeedButton;
    lytPatientProfile: TLayout;
    lytProfilePhoto: TLayout;
    cProfilePhoto: TCircle;
    gIcon: TGlyph;
    lNameH: TLabel;
    lytDetailH: TLayout;
    lytStatusH: TLayout;
    rRoleH: TRectangle;
    rStatusH: TRectangle;
    lName: TLabel;
    Line1: TLine;
    lytContactInfoH: TLayout;
    lytContactTitle: TLayout;
    lytEmailH: TLayout;
    lytPhone: TLayout;
    gContactInfo: TGlyph;
    lContactTitle: TLabel;
    gEmail: TGlyph;
    slEmail: TSkLabel;
    slPhone: TSkLabel;
    gRole: TGlyph;
    lRole: TLabel;
    lStatus: TLabel;
    Line2: TLine;
    lytWorkInfoH: TLayout;
    lytWorkTitle: TLayout;
    gWorkInfo: TGlyph;
    lWorkInfo: TLabel;
    lytRole: TLayout;
    slRole: TSkLabel;
    lytDepartment: TLayout;
    slDepartment: TSkLabel;
    lytWorkInfo1: TLayout;
    lytWorkInfo2: TLayout;
    lytHireDate: TLayout;
    slHireDate: TSkLabel;
    lytLastLogin: TLayout;
    slLastLogin: TSkLabel;
    lytBottom: TLayout;
    cEmail: TCircle;
    cPhone: TCircle;
    gPhone: TGlyph;
    cRole: TCircle;
    gReceptionist: TGlyph;
    cDepartment: TCircle;
    gDepartment: TGlyph;
    cHireDate: TCircle;
    gHireDate: TGlyph;
    cLastLogin: TCircle;
    gLastLogin: TGlyph;
    lytSection1: TLayout;
    btnEdit: TCornerButton;
    btnDelete: TCornerButton;
    rDeleteBackground: TRectangle;
    rDeleteModal: TRectangle;
    lytDeleteInfo: TLayout;
    lDeleteDesc: TLabel;
    lytDeleteButtonH: TLayout;
    btnDeleteCancel: TCornerButton;
    btnDeleteUser: TCornerButton;
    lytDeleteTitle: TLayout;
    lDeleteTItle: TLabel;
    btnDeleteClose: TSpeedButton;
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure btnDeleteCancelClick(Sender: TObject);
    procedure btnDeleteCloseClick(Sender: TObject);
    procedure btnDeleteUserClick(Sender: TObject);
  private
    procedure EditComponentsResponsive;
    { Private declarations }
  public
    { Public declarations }
    procedure ClearItems;
  end;

implementation

{$R *.fmx}

uses uDm, uMain, uToolbar;

{ Clear Items }
procedure TfUserDetails.ClearItems;
var
  Parts: TArray<string>;
  Initials: string;
begin
  // Getter of first letter of the Full name
  if lName.Text.Trim <> '' then
  begin
    Parts := lName.Text.Trim.Split([' ']); // split by space
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
  end;

  // Icon visibility
  if lName.Text.Trim = '' then
  begin
    lNameH.Text := '';
    gIcon.ImageIndex := 10;
    lNameH.Visible := False;
  end;
end;

{ Close Button }
procedure TfUserDetails.btnCloseClick(Sender: TObject);
begin
  Self.Visible := False;
end;

{ Cancel Button - Delete }
procedure TfUserDetails.btnDeleteCancelClick(Sender: TObject);
begin
  rDeleteBackground.Visible := False;
end;

{ Close Button - Delete }
procedure TfUserDetails.btnDeleteCloseClick(Sender: TObject);
begin
  rDeleteBackground.Visible := False;
end;

{ Delete User Button }
procedure TfUserDetails.btnDeleteUserClick(Sender: TObject);
begin
  with dm.qUsers do
  begin
    // Set record pop up message
    frmMain.Tag := 8;
    frmMain.RecordMessage('User', lName.Text);

    Delete;
    Refresh;
    Self.Visible := False;
  end;
end;

{ Delete Button }
procedure TfUserDetails.btnDeleteClick(Sender: TObject);
begin
  // Check if user role is not Admin
  if not (dm.User.RoleH = 'Admin') then
  begin
    TDialogService.MessageDialog(
      'Only an admin can Delete a user.',
      TMsgDlgType.mtError,  // info icon
      [TMsgDlgBtn.mbOK],
      TMsgDlgBtn.mbOK, 0,
      nil  // No callback, so code continues immediately
    );
    Exit;
  end;

  try
    dm.qTemp.Close;
    dm.qTemp.SQL.Text :=
    'SELECT COUNT(user_role) AS AdminCount ' +
    'FROM users WHERE user_role = ''Admin''';
    dm.qTemp.Open;

    if (dm.qTemp.FieldByName('AdminCount').asInteger = 1) then
    begin
      TDialogService.MessageDialog(
        'Deletion is not permitted because this is the only remaining admin account',
        TMsgDlgType.mtError,  // info icon
        [TMsgDlgBtn.mbOK],
        TMsgDlgBtn.mbOK, 0,
        nil  // No callback, so code continues immediately
      );
      Exit;  // Stop the save operation
    end;
  finally
    dm.qTemp.Close;
  end;

  rDeleteBackground.Visible := True;
  lDeleteDesc.Text := 'This will permanently delete '  + lName.Text + '`s ' + 'account. This action cannot be undone.';
end;

{ Edit Button }
procedure TfUserDetails.btnEditClick(Sender: TObject);
var
  roleH, statusH: String;
  ms: TMemoryStream;
begin
  frmMain.fUserModal.ClearItems;

  // Check if user role is not Admin
  if not (dm.User.RoleH = 'Admin') then
  begin
    TDialogService.MessageDialog(
      'Only an admin can Edit a user.',
      TMsgDlgType.mtError,  // info icon
      [TMsgDlgBtn.mbOK],
      TMsgDlgBtn.mbOK, 0,
      nil  // No callback, so code continues immediately
    );
    Exit;
  end;

  Self.Visible := False;  // Hide UserDetails modal
  dm.RecordStatus := 'Edit'; // Set record Status
  frmMain.fUserModal.lbTitle.Text := 'Update Existing Patient'; // Set title
  frmMain.fUserModal.btnSaveUser.Text := 'Update Patient';  // set text in the button

  // Show Change Password section
  frmMain.fUserModal.rSecuritySettings.Opacity := 1;
  frmMain.fUserModal.rSecuritySettings.Height := 220;

  frmMain.fUserModal.lytPassword.Visible := False;
  frmMain.fUserModal.rUser.Height := 575;

  // Populate the modal form
  // Get Fullname
  frmMain.fUserModal.eFullName.Text := dm.qUsers.FieldByName('name').AsString;

  // Get username
  frmMain.fUserModal.eUsername.Text :=
    dm.qUsers.FieldByName('username').AsString;

  // Get password
  frmMain.fUserModal.ePassword.Text :=
    dm.qUsers.FieldByName('password').AsString;

  // Get email address
  frmMain.fUserModal.eEmailAddress.Text :=
    dm.qUsers.FieldByName('email_address').AsString;

  // Get contact number
  frmMain.fUserModal.eContactNumber.Text :=
    dm.qUsers.FieldByName('contact_number').AsString;

  // Get Profile Photo
  // Load Profile Photo (LONGBLOB -> TImage)
  ms := TMemoryStream.Create;
  try
    if not dm.qUsers.FieldByName('profile_pic').IsNull then
    begin
      frmMain.fUserModal.cProfilePhoto.Fill.Kind := TBrushKind.Bitmap;
      TBlobField(dm.qUsers.FieldByName('profile_pic')).SaveToStream(ms);
      ms.Position := 0;
      frmMain.fUserModal.cProfilePhoto.Fill.Bitmap.Bitmap.LoadFromStream(ms);
      frmMain.fUserModal.lNameH.Visible := False;  // Hide Name holder
    end
    else
    begin
      frmMain.fUserModal.cProfilePhoto.Fill.Bitmap.Bitmap := nil; // Clear if no photo
      frmMain.fUserModal.cProfilePhoto.Fill.Kind := TBrushKind.Solid;  // Set background
    end;
  finally
    frmMain.fUserModal.gIcon.ImageIndex := -1; // Hide Icon
    frmMain.fUserModal.cProfilePhoto.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    ms.Free;
  end;

  // Get user role in the database
  roleH := dm.qUsers.FieldByName('user_role').AsString;
  if roleH = 'Admin' then
    frmMain.fUserModal.cbRole.ItemIndex := 0
  else
    frmMain.fUserModal.cbRole.ItemIndex := 1;

  // Get Department
  frmMain.fUserModal.eDepartment.Text :=
    dm.qUsers.FieldByName('department').AsString;

  // Get status in the database
  statusH := dm.qUsers.FieldByName('status').AsString;
  if statusH = 'Active' then
    frmMain.fUserModal.cbRole.ItemIndex := 0
  else
    frmMain.fUserModal.cbRole.ItemIndex := 1;

  frmMain.fUserModal.Visible := True; // Show patient modal
end;

{ Layout Responsiveness adjuster }
procedure TfUserDetails.EditComponentsResponsive;
begin
  lytEmailH.Width := Trunc(lytContactInfoH.Width / 2) - 15; // -15 to account for spacing
  lytPhone.Width := Trunc(lytContactInfoH.Width / 2) - 15;
  lytRole.Width := Trunc(lytWorkInfo1.Width / 2) - 15;
  lytDepartment.Width := Trunc(lytWorkInfo1.Width / 2) - 15;
  lytHireDate.Width := Trunc(lytWorkInfo2.Width / 2) - 15;
  lytLastLogin.Width := Trunc(lytWorkInfo2.Width / 2) - 15;
end;

{ Frame Resize }
procedure TfUserDetails.FrameResize(Sender: TObject);
begin
  EditComponentsResponsive;

  if (frmMain.ClientWidth >= 1920) then
  begin
    rModalInfo.Margins.Left := 580;
    rModalInfo.Margins.Right := 580;
    rModalInfo.Margins.Top := 235;
    rModalInfo.Margins.Bottom := 235;
  end
  else if (frmMain.ClientWidth >= 1366) then
  begin
    rModalInfo.Margins.Left := 300;
    rModalInfo.Margins.Right := 300;
    rModalInfo.Margins.Top := 90;
    rModalInfo.Margins.Bottom := 90;
  end
  else if (frmMain.ClientHeight <= 510) AND (frmMain.ClientWidth <= 860) then
  begin
    rModalInfo.Margins.Left := 90;
    rModalInfo.Margins.Right := 90;
    rModalInfo.Margins.Top := 50;
    rModalInfo.Margins.Bottom := 50;
  end;
end;

end.
