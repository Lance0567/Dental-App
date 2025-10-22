unit uUserProfile;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.ImgList,
  FMX.DateTimeCtrls, FMX.Edit, FMX.TabControl, FMX.Memo.Types, FMX.ScrollBox,
  FMX.Memo;

type
  TfUserProfile = class(TFrame)
    lytUserBriefInfo: TLayout;
    lytPersonalInfo: TLayout;
    rPersonalInfo: TRectangle;
    rUserBriefinfo: TRectangle;
    lytUserH: TLayout;
    rrUserPhoto: TRoundRect;
    lUserNameH: TLabel;
    LEmailH: TLabel;
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
    lytDateOfBirth: TLayout;
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
    lytDetails2: TLayout;
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
    procedure tcControllerChanging(Sender: TObject; var AAllowChange: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm;

procedure TfUserProfile.tcControllerChanging(Sender: TObject;
  var AAllowChange: Boolean);
begin
  // Change database connection according to the selected tab
  case tcController.TabIndex of
    0:
    begin
      lytContent.Height := 560;
    end;
    1:
    begin
      lytContent.Height := 445;
    end;
  end;
end;

end.
