unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Skia,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.Skia, FMX.Layouts,
  FMX.Objects, FMX.Platform, FMX.Effects, FMX.ImgList, System.Hash,
  FireDAC.Stan.Param, System.Math, FMX.DialogService, Data.DB, uUserModal;

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
    procedure btnLoginClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnMinimizeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rDragMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure rDragMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure rDragMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
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

uses uDm, uMain, uAdminSetup;

{ Close Button }
procedure TfrmLogin.btnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

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
      frmAdminSetup := TfrmAdminSetup.Create(Application);

      // Open database
      dm.qUsers.Open;

      // Pre populate fields
      frmAdminSetup.fUserModal.lbTitle.Text := 'Add Admin User';
      frmAdminSetup.fUserModal.eUsername.ReadOnly := True;
      frmAdminSetup.fUserModal.eUsername.Text := 'admin';
      frmAdminSetup.fUserModal.cbRole.ItemIndex := 0;
      frmAdminSetup.fUserModal.eDepartment.Text := 'Administration';
      frmAdminSetup.fUserModal.rRoleAndAccess.Visible := False; // Hide Role & Access section
      frmAdminSetup.ShowModal;

      // Close database
      dm.qUsers.Close;
    end;
    Close;
  end;
end;

{ Login Button }
procedure TfrmLogin.btnLoginClick(Sender: TObject);
var
  InputUser, InputPass, InputPassHash: string;
begin
  HasRecord := False; // Record checker trigger
  InputUser := Trim(eUsername.Text);
  InputPass := ePassword.Text; // Do NOT trim passwords!
  InputPassHash := THashSHA2.GetHashString(InputPass);

  CheckRecords; // Record checker

  if HasRecord then
  begin
    Exit;
  end;

  with dm.qTemp do
  begin
    Close;
    SQL.Text := 'SELECT username FROM users WHERE username = :u AND password = :p';
    ParamByName('u').AsString := InputUser;
    ParamByName('p').AsString := InputPassHash;
    Open;
    if not IsEmpty then
    begin
      ShowMessage('Login successful!');
      frmMain := TfrmMain.Create(Self);
      frmMain.Show;
      frmLogin.Visible := False;
    end
    else
      ShowMessage('Invalid username or password.');
    Close;
  end;
end;

{ Minimize }
procedure TfrmLogin.btnMinimizeClick(Sender: TObject);
begin
  WindowState := TWindowState.wsMinimized;
end;

{ Form Show }
procedure TfrmLogin.FormShow(Sender: TObject);
begin
  dm.FormReader := 'Login';
  CheckRecords; // Record Checker
end;

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
