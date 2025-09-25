unit uUpdateProfilePhoto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TfUpdateProfilePhoto = class(TFrame)
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
    lNameH: TLabel;
    lytPhotoButton: TLayout;
    lytPhotoButtonH: TLayout;
    btnPhotoUpload: TCornerButton;
    btnCamera: TCornerButton;
    cbRemove: TCornerButton;
    lProfileUploadDesc: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
