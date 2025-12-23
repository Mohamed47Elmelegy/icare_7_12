import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:icare/features/search/domain/entities/searchable_entity.dart';

@immutable
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchSuccessState extends SearchState {
  final List<SearchableEntity> results;

  const SearchSuccessState({required this.results});

  @override
  List<Object?> get props => [results];
}

class SearchErrorState extends SearchState {
  final String message;

  const SearchErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProviderTypeSelectedState extends SearchState {
  final String providerType;

  const ProviderTypeSelectedState({required this.providerType});

  @override
  List<Object?> get props => [providerType];
}

class ServicesSelectedState extends SearchState {
  final List<int> serviceIds;

  const ServicesSelectedState({required this.serviceIds});

  @override
  List<Object?> get props => [serviceIds];
}
