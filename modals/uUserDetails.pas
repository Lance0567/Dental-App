unit uUserDetails;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, FMX.ListBox, FMX.Skia, FMX.ImgList, FMX.Objects, FMX.Edit,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TfUserDetails = class(TFrame)
    lytContentH: TLayout;
    rBackground: TRectangle;
    rModalInfo: TRectangle;
    ScrollBox1: TScrollBox;
    lytTitle: TLayout;
    lbTitle: TLabel;
    btnClose: TSpeedButton;
    rUser: TRectangle;
    lytUserH: TLayout;
    lytPatientProfile: TLayout;
    lytProfilePhoto: TLayout;
    cProfilePhoto: TCircle;
    gIcon: TGlyph;
    lNameH: TLabel;
    lytPhotoButton: TLayout;
    lytPhotoButtonH: TLayout;
    lProfileUploadDesc: TLabel;
    lytButtonSaveH: TLayout;
    btnCreateUser: TCornerButton;
    lTag: TLabel;
    btnCancel: TCornerButton;
    lPersonalInfo: TLabel;
    rRoleH: TRectangle;
    Rectangle1: TRectangle;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
