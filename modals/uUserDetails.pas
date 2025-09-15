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
    lytPatientProfile: TLayout;
    lytProfilePhoto: TLayout;
    cProfilePhoto: TCircle;
    gIcon: TGlyph;
    lNameH: TLabel;
    lytPhotoButton: TLayout;
    lytPhotoButtonH: TLayout;
    rRoleH: TRectangle;
    rStatusH: TRectangle;
    lPersonalInfo: TLabel;
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
    Layout1: TLayout;
    cEmail: TCircle;
    Circle1: TCircle;
    gPhone: TGlyph;
    cRole: TCircle;
    gReceptionist: TGlyph;
    cDepartment: TCircle;
    gDepartment: TGlyph;
    cHireDate: TCircle;
    gHireDate: TGlyph;
    cLastLogin: TCircle;
    gLastLogin: TGlyph;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm;

end.
