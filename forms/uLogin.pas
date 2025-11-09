unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Skia,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.Skia, FMX.Layouts,
  FMX.Objects, FMX.Platform, FMX.Effects, FMX.ImgList, System.Hash,
  FireDAC.Stan.Param, System.Math, FMX.DialogService, Data.DB, System.IniFiles,
  System.IOUtils;

type
  TfrmLogin = class(TForm)
    rLogin: TRectangle;
    lytBorder: TLayout;
    lytLogo: TLayout;
    slSignIn: TSkLabel;
    lytUsername: TLayout;
    lbUserName: TLabel;
    eUsername: TEdit;
    lytPassword: TLayout;
    lbPassword: TLabel;
    ePassword: TEdit;
    lytBottom: TLayout;
    cbRememberMe: TCheckBox;
    lDivider: TLine;
    lytLoginAndCancel: TLayout;
    btnLogin: TCornerButton;
    btnCancel: TCornerButton;
    seLogin: TShadowEffect;
    lytHelp: TLayout;
    lbCantSignIn: TLabel;
    btnGiveMeHelp: TCornerButton;
    lytCreateAccount: TLayout;
    lbCreateAccount: TLabel;
    btnCreateAccount: TCornerButton;
    btnMinimize: TSpeedButton;
    rLogo: TRectangle;
    lbLogoTitle: TLabel;
    gLogo: TGlyph;
    btnClose: TSpeedButton;
    rDrag: TRectangle;
    cbShowPassword: TCheckBox;
    lytContentH: TLayout;
    rBackground: TRectangle;
    rModalInfo: TRectangle;
    lytPatientProfile: TLayout;
    lLance: TLabel;
    lNumber1: TLabel;
    lFrnacis: TLabel;
    lNumber2: TLabel;
    lytTitle: TLayout;
    ShadowEffect1: TShadowEffect;
    lbTitle2: TLabel;
    lInfo1: TLabel;
    lytTop1: TLayout;
    lTitle1: TLabel;
    btnCloseModal: TSpeedButton;
    procedure btnLoginClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rDragMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rDragMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure rDragMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure eUsernameKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure cbShowPasswordChange(Sender: TObject);
    procedure ePasswordKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure ePasswordEnter(Sender: TObject);
    procedure ePasswordExit(Sender: TObject);
    procedure cbShowPasswordClick(Sender: TObject);
    procedure btnCreateAccountClick(Sender: TObject);
    procedure btnCloseModalClick(Sender: TObject);
    procedure btnGiveMeHelpClick(Sender: TObject);
  private
    HasRecord: Boolean;
    procedure CheckRecords;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;
  IsDragging: Boolean;
  StartMousePos: TPointF;
  StartFormPos: TPointF;

implementation

{$R *.fmx}

uses uDm, uMain, uAdminSetup, uToolbar, uUserModal, uGlobal;

{ Remember me }
procedure SaveRememberMeUsername(const AUsername: string);
var
  Ini: TMemIniFile;
  IniFileName: string;
begin
  IniFileName := TPath.Combine(TPath.GetHomePath, 'MyAppSettings.ini');
  Ini := TMemIniFile.Create(IniFileName);
  try
    if AUsername <> '' then
      Ini.WriteString('Login', 'Username', AUsername)
    else
      Ini.DeleteKey('Login', 'Username');
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

{ Close Button }
procedure TfrmLogin.btnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

{ Check Records }
procedure TfrmLogin.CheckRecords;
begin
  with dm.qTemp do
  begin
    Close;
    SQL.Text := 'SELECT COUNT(id) AS usercount FROM users';
    Open;
    if (not FieldByName('usercount').IsNull) and (FieldByName('usercount').AsInteger = 0) then
    begin
      TDialogService.MessageDialog(
        'No users found. You must set up the first admin account.',
        TMsgDlgType.mtInformation,  // info icon
        [TMsgDlgBtn.mbOK],
        TMsgDlgBtn.mbOK, 0,
        nil  // No callback, so code continues immediately
      );
      HasRecord := True;  // Record checker trigger
      if not Assigned(frmAdminSetup) then
        Application.CreateForm(TfrmAdminSetup, frmAdminSetup);

      // Open database
      dm.qUsers.Open;

      // Pre populate fields
      frmAdminSetup.fUserModal.ClearItems;
      frmAdminSetup.fUserModal.lbTitle.Text := 'Add Admin User';
      frmAdminSetup.fUserModal.eUsername.ReadOnly := True;
      frmAdminSetup.fUserModal.eUsername.Text := 'admin';
      frmAdminSetup.fUserModal.cbRole.ItemIndex := 0;
      frmAdminSetup.fUserModal.eDepartment.Text := 'Administration';
      frmAdminSetup.fUserModal.rRoleAndAccess.Visible := False; // Hide Role & Access section
      dm.FormReader := 'Login';
      dm.RecordStatus := 'Add';
      frmAdminSetup.ShowModal;

      // Close database
      dm.qUsers.Close;
    end;
    Close;
  end;
end;

{ Password OnEnter }
procedure TfrmLogin.ePasswordEnter(Sender: TObject);
begin
  cbShowPassword.Visible := True;
end;

{ Password OnExit }
procedure TfrmLogin.ePasswordExit(Sender: TObject);
begin
  cbShowPassword.Visible := False;
end;

{ Password Key down }
procedure TfrmLogin.ePasswordKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    btnLoginClick(Sender);
    Key := 0; // Optional: prevent beep
  end;
end;

{ Username Key down }
procedure TfrmLogin.eUsernameKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    ePassword.SetFocus;
    Key := 0; // Optional: prevent beep
  end;
end;

{ Close Modal Help }
procedure TfrmLogin.btnCloseModalClick(Sender: TObject);
begin
  lytContentH.Visible := False;
end;

{ Create New Account Button }
procedure TfrmLogin.btnCreateAccountClick(Sender: TObject);
begin
  // Create frmAdminSetup form
  if not Assigned(frmAdminSetup) then
    Application.CreateForm(TfrmAdminSetup, frmAdminSetup);

  // Clear items in user modal
  frmAdminSetup.fUserModal.ClearItems;
  frmAdminSetup.fUserModal.rRoleAndAccess.Visible := False;

  frmAdminSetup.fUserModal.lbTitle.Text := 'Add New User';  // Set title
  frmAdminSetup.Caption := 'Create New User Account'; // Set form caption
  frmAdminSetup.fUserModal.btnSaveUser.Text := 'Create User'; // Button caption
  frmAdminSetup.fUserModal.cbRole.Enabled := False; // Set Role dropdown to read only
  frmAdminSetup.fUserModal.cbRole.ItemIndex := 1; //  Set to 'Receptionist'
  frmAdminSetup.fUserModal.cbStatus.Enabled := False; // Set Status dropdown to read only
  frmAdminSetup.fusermodal.eDepartment.Text := 'Front Desk';
  frmAdminSetup.fUserModal.cbStatus.ItemIndex := 0; // Set to Active

  frmAdminSetup.ShowModal;  // Show modal form
end;

{ Help Button }
procedure TfrmLogin.btnGiveMeHelpClick(Sender: TObject);
begin
  lytContentH.Visible := True;
end;

{ Login Button }
procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  InputUser, InputPass, DateAndTime, InputPassHash: string;
begin
  HasRecord := False; // Record checker trigger
  InputUser := Trim(eUsername.Text);
  InputPass := ePassword.Text; // Do NOT trim passwords!
  InputPassHash := THashSHA2.GetHashString(InputPass);
  DateAndTime := FormatDateTime('mmmm dd, yyyy "at" hh:nn AM/PM', Now); // Get date and time now

  if dm.conDental.Connected = False then
    dm.conDental.Connected := True;

  CheckRecords; // Record checker

  if HasRecord then
  begin
    Exit;
  end;

  with dm.qTemp do
  begin
    Close;
    SQL.Text :=
      'SELECT id, name, email_address, contact_number, username, user_role, password, last_login, bio ' +
      'FROM users ' +
      'WHERE username = :u AND password = :p';
    ParamByName('u').AsString := InputUser;
    ParamByName('p').AsString := InputPassHash;
    Open;
    if not IsEmpty then
    begin
      dm.User.IDH := FieldByName('id').AsInteger;  // Get Fullname
      dm.User.FullnameH := FieldByName('name').AsString;  // Get Fullname
      dm.User.UsernameH := FieldByName('username').AsString; // Get username
      dm.User.RoleH := FieldByName('user_role').AsString;; // Get role
      dm.User.PasswordH := FieldByName('password').AsString; // Get password
      dm.User.EmailH := FieldByName('email_address').AsString;  // Get email
      dm.User.PhoneH := FieldByName('contact_number').AsString;  // Get Phone number
      dm.User.BioH := FieldByName('bio').AsString;  // Get bio

      // Record the login date & time
      Edit;
      FieldByName('last_login').AsString := DateAndTime;  // Insert last login
      Post;
      Refresh;

      TDialogService.MessageDialog(
        'Login successful!',
        TMsgDlgType.mtInformation,  // info icon
        [TMsgDlgBtn.mbOK],
        TMsgDlgBtn.mbOK, 0,
        nil  // No callback, so code continues immediately
      );

      // Remember me
      if cbRememberMe.IsChecked then
        SaveRememberMeUsername(InputUser)
      else
        SaveRememberMeUsername('');  // Clear saved username

      if not Assigned(frmMain) then
        Application.CreateForm(TfrmMain, frmMain);

      // Assign Main form
      Application.MainForm := frmMain;

      // Hide Login form & show Main form
      frmMain.Show;
      frmLogin.Free;
      frmLogin := nil;
    end
    else
      TDialogService.MessageDialog(
        'Invalid username or password.',
        TMsgDlgType.mtError,  // info icon
        [TMsgDlgBtn.mbOK],
        TMsgDlgBtn.mbOK, 0,
        nil  // No callback, so code continues immediately
      );
    Close;
  end;
end;

{ Minimize Button }
procedure TfrmLogin.btnMinimizeClick(Sender: TObject);
begin
  WindowState := TWindowState.wsMinimized;
end;

{ Show Password Onchanges }
procedure TfrmLogin.cbShowPasswordChange(Sender: TObject);
begin
  if cbShowPassword.IsChecked then
    ePassword.Password := False
  else
    ePassword.Password := True;
end;

procedure TfrmLogin.cbShowPasswordClick(Sender: TObject);
begin
  ePassword.SetFocus;
end;

{ Form Show }
procedure TfrmLogin.FormShow(Sender: TObject);
var
  SavedUser: string;
begin
  dm.FormReader := 'Login';

  {$IFDEF DEBUG}
    eUsername.Text := 'admin';
    ePassword.Text := 'admin';
    btnLogin.SetFocus;
  {$ENDIF}

  // Hide Show password
  cbShowPassword.Visible := False;

  // Create Main form
  if not Assigned(frmMain) then
    Application.CreateForm(TfrmMain, frmMain);

  if not Assigned(frmAdminSetup) then
    Application.CreateForm(TfrmAdminSetup, frmAdminSetup);

  // Record Checker
  CheckRecords;

  // Load Remember me
  SavedUser := LoadRememberMeUsername;
  if SavedUser <> '' then
  begin
    eUsername.Text := SavedUser;
    cbRememberMe.IsChecked := True;
    ePassword.SetFocus; // user can enter password quickly
  end
  else
  begin
    cbRememberMe.IsChecked := False;
  end;
end;

{ rDrag for borderless login form with draggable feature }
procedure TfrmLogin.rDragMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  if Button = TMouseButton.mbLeft then
  begin
    IsDragging := True;
    StartMousePos := Screen.MousePos; // absolute mouse position
    StartFormPos := PointF(Self.Left, Self.Top);
  end;
end;

procedure TfrmLogin.rDragMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
var
  CurrentMousePos: TPointF;
  Delta: TPointF;
begin
  if IsDragging and (ssLeft in Shift) then
  begin
    CurrentMousePos := Screen.MousePos;
    Delta := PointF(CurrentMousePos.X - StartMousePos.X, CurrentMousePos.Y - StartMousePos.Y);

    // Smooth motion: add only a fraction of delta for fluid movement
    Self.Left := Round(StartFormPos.X + Delta.X);
    Self.Top  := Round(StartFormPos.Y + Delta.Y);
  end;
end;

procedure TfrmLogin.rDragMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  if Button = TMouseButton.mbLeft then
  begin
    IsDragging := False;
  end;
end;

end.
