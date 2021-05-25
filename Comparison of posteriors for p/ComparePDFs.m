% compare pdf for different pairs of neurons either between or within
% studies

%% prelude

clear all
close all

% addpath('../../../BrewerMap')
% scheme_d1 = 'Blues';
% scheme_d2 = 'Reds';
% cm = colormap([brewermap(2,scheme_d1); brewermap(2,scheme_d2)]);
% rmpath('../../../BrewerMap')
cm = colormap(lines);
close gcf

%% introduction

Taverna = load('../Posteriors for p/Taverna posterior with literature prior');
Planert = load('../Posteriors for p/Planert posterior with literature prior');

% prior = 'uniform';
% 
% Taverna = load(['Taverna/Taverna posterior with ' prior]);
% Planert = load(['Planert/Planert posterior with ' prior]);
% Cepeda = load(['Cepeda/Cepeda posterior with ' prior]);
% CepedaR62 = load(['CepedaR62/CepedaR62 posterior with ' prior]);
% Tecuapetla = load(['Tecuapetla/Tecuapetla posterior with ' prior]);
% Krajeski = load(['Krajeski/Krajeski posterior with ' prior]);
% Combined = load(['Combined/Combined posterior with ' prior]);

%% within comparisons

pairs = {'d1_dx', 'd2_dx'};

WithinDeltaFigures(Taverna, pairs, cm)
WithinDeltaFigures(Planert, pairs, cm)

% SeparateDeltaFigures(Cepeda, pairings, cm)
% SeparateDeltaFigures(CepedaR62, pairings, cm)
% %SeparateDeltaFigures(Tecuapetla, {'d2_d2', 'd2_d1'}, cm)
% SeparateDeltaFigures(Combined, pairings, cm)
% SeparateDeltaFigures(Krajeski, pairings, cm)

%% between comparisons

% pairs = {'d1_dx', 'd2_dx'};
% 
% BetweenDeltaFigures(Taverna, Planert, pairs, cm([2,4],:))
