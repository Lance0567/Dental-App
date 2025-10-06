unit uAppointmentModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, FMX.Skia, FMX.ListBox, FMX.Effects, FMX.Objects, FMX.Edit,
  FMX.ImgList, FMX.Controls.Presentation, FMX.Layouts, FMX.DateTimeCtrls,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TfAppointmentModal = class(TFrame)
    lytContentH: TLayout;
    rBackground: TRectangle;
    rModalInfo: TRectangle;
    ScrollBox1: TScrollBox;
    lytTitle: TLayout;
    lbTitle: TLabel;
    btnClose: TSpeedButton;
    lytHolder: TLayout;
    lytDetails1: TLayout;
    lPatient: TLabel;
    crPatient: TCalloutRectangle;
    gPatient: TGlyph;
    lPatientW: TLabel;
    ShadowEffect1: TShadowEffect;
    cbPatient: TComboBox;
    lytDetails2: TLayout;
    lAppointmentTitle: TLabel;
    eAppointmentTitle: TEdit;
    crAppointmentTitle: TCalloutRectangle;
    gAppointmentTitle: TGlyph;
    lAppointmentTitleW: TLabel;
    ShadowEffect2: TShadowEffect;
    lytDetails3: TLayout;
    lytStatus: TLayout;
    lStatus: TLabel;
    cbStatus: TComboBox;
    lytDate: TLayout;
    lDate: TLabel;
    deDate: TDateEdit;
    lytDetails4: TLayout;
    lytEndTIme: TLayout;
    lEndTime: TLabel;
    lytStartTime: TLayout;
    lStartTime: TLabel;
    teStartTime: TTimeEdit;
    teEndTime: TTimeEdit;
    lytDetails5: TLayout;
    lNotes: TLabel;
    mNotes: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
