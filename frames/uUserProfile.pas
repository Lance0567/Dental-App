unit uUserProfile;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, FMX.ImgList,
  FMX.DateTimeCtrls, FMX.Edit;

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
    lbDescription: TLabel;
    lbTitle: TLabel;
    lytDetails1: TLayout;
    lytFullName: TLayout;
    lbFullName: TLabel;
    eFullName: TEdit;
    lytDateOfBirth: TLayout;
    lUsername: TLabel;
    lytEmail: TLayout;
    eUserName: TEdit;
    eEmail: TEdit;
    lEmail: TLabel;
    lytPhoneNumber: TLayout;
    ePhoneNumber: TEdit;
    lPhone: TLabel;
    ScrollBox1: TScrollBox;
    lytMyAccount: TLayout;
    lFrameDesc: TLabel;
    lFrameTitle: TLabel;
    lytContent: TLayout;
    gUserPhoto: TGlyph;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm;

end.
