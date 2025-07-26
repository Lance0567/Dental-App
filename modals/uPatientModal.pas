unit uPatientModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.ImgList, FMX.Controls.Presentation;

type
  TfPatientModal = class(TFrame)
    rBackground: TRectangle;
    rModalInfo: TRectangle;
    lytPatientH: TLayout;
    lytMedicalNotes: TLayout;
    lytButtonSaveH: TLayout;
    btnSavePatient: TCornerButton;
    lytContentH: TLayout;
    lytPatientProfile: TLayout;
    lytPatientDetails: TLayout;
    lytTitle: TLayout;
    lbTitle: TLabel;
    lbMedicalNotes: TLabel;
    cProfilePhoto: TCircle;
    lbProfilePhoto: TLabel;
    btnPhotoUpload: TCornerButton;
    Glyph1: TGlyph;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm;

end.
