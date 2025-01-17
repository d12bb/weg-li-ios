// Created for weg-li in 2021.

import ComposableArchitecture
import SwiftUI

struct EditDescriptionView: View {
    struct ViewState: Equatable {
        let description: DescriptionState

        init(state: Report) {
            description = state.description
        }
    }

    let store: Store<Report, ReportAction>
    @ObservedObject private var viewStore: ViewStore<ViewState, ReportAction>

    init(store: Store<Report, ReportAction>) {
        self.store = store
        viewStore = ViewStore(store.scope(state: ViewState.init))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(L10n.Description.Section.Vehicle.copy)) {
                    licensePlateView
                    carBrandView
                    carColorView
                }
                .padding(.top, 4)
                .textFieldStyle(PlainTextFieldStyle())
                Section(header: Text(L10n.Description.Section.Violation.copy)) {
                    chargTypeView
                    chargeLengthView
                    blockedOthersView
                }
            }
            .navigationBarItems(leading: closeButton)
            .navigationBarTitle(Text(L10n.Description.widgetTitle), displayMode: .inline)
        }
    }

    private var licensePlateView: some View {
        TextField(
            "\(L10n.Description.Row.licensplateNumber) *",
            text: viewStore.binding(
                get: \.description.licensePlateNumber,
                send: { ReportAction.description(.setLicensePlateNumber($0)) }
            )
        )
    }

    private var carBrandView: some View {
        Picker(
            L10n.Description.Row.carType,
            selection: viewStore.binding(
                get: \.description.selectedBrand,
                send: { ReportAction.description(.setBrand($0)) }
            )
        ) {
            ForEach(1..<DescriptionState.brands.count, id: \.self) {
                Text(DescriptionState.brands[$0])
                    .tag($0)
                    .foregroundColor(Color(.label))
            }
            .navigationTitle(Text(L10n.Description.Row.carType))
        }
    }

    private var carColorView: some View {
        Picker(
            L10n.Description.Row.carColor,
            selection: viewStore.binding(
                get: \.description.selectedColor,
                send: { ReportAction.description(.setColor($0)) }
            )
        ) {
            ForEach(1..<DescriptionState.colors.count, id: \.self) {
                Text(DescriptionState.colors[$0].value)
                    .tag($0)
                    .foregroundColor(Color(.label))
            }
            .navigationTitle(Text(L10n.Description.Row.carColor))
        }
    }

    private var chargTypeView: some View {
        Picker(
            L10n.Description.Row.chargeType,
            selection: viewStore.binding(
                get: \.description.selectedType,
                send: { ReportAction.description(.setCharge($0)) }
            )
        ) {
            ForEach(1..<DescriptionState.charges.count, id: \.self) {
                Text(DescriptionState.charges[$0].value)
                    .tag($0)
                    .foregroundColor(Color(.label))
            }
            .navigationTitle(Text(L10n.Description.Row.chargeType))
        }
    }

    private var chargeLengthView: some View {
        Picker(
            L10n.Description.Row.length,
            selection: viewStore.binding(
                get: \.description.selectedDuration,
                send: { ReportAction.description(.setDuraration($0)) }
            )
        ) {
            ForEach(1..<Times.allCases.count, id: \.self) {
                Text(Times.allCases[$0].description)
                    .foregroundColor(Color(.label))
            }
            .navigationTitle(Text(L10n.Description.Row.length))
        }
    }

    private var blockedOthersView: some View {
        Button(
            action: {
                viewStore.send(ReportAction.description(.toggleBlockedOthers))
            },
            label: {
                HStack {
                    Text(L10n.Description.Row.didBlockOthers)
                        .foregroundColor(.secondary)
                    Spacer()
                    ToggleButton(
                        isOn: viewStore.binding(
                            get: \.description.blockedOthers,
                            send: { _ in ReportAction.description(.toggleBlockedOthers) }
                        )
                    ).animation(.easeIn(duration: 0.1))
                }
            }
        )
    }

    private var closeButton: some View {
        Button(
            action: { viewStore.send(.setShowEditDescription(false)) },
            label: { Text(L10n.Button.close) }
        )
    }
}

struct Description_Previews: PreviewProvider {
    static var previews: some View {
        Preview {
            EditDescriptionView(
                store: .init(
                    initialState: .init(
                        images: .init(),
                        contact: .preview,
                        date: Date.init,
                        location: LocationViewState()
                    ),
                    reducer: .empty,
                    environment: ()
                )
            )
        }
    }
}
