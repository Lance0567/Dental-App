unit uLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Skia,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.Skia, FMX.Layouts,
  FMX.Objects, FMX.Effects, FMX.ImgList;

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
    btnClose: TSpeedButton;
    btnMinimize: TSpeedButton;
    rLogo: TRectangle;
    lbLogoTitle: TLabel;
    gLogo: TGlyph;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

uses uDm;

end.
