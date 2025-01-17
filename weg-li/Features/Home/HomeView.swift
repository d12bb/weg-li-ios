// Created for weg-li in 2021.

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    private let store: Store<HomeState, HomeAction>
    @ObservedObject private var viewStore: ViewStore<HomeState, HomeAction>

    init(store: Store<HomeState, HomeAction>) {
        self.store = store
        viewStore = ViewStore(store)
    }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                if viewStore.reports.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        ForEach(viewStore.reports, id: \.id) { report in
                            ReportCellView(report: report)
                        }
                        .padding()
                    }
                }
                addReportButton
                    .padding(24)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarTitle(L10n.Home.navigationBarTitle)
            .navigationBarItems(trailing: contactData)
            .onAppear { viewStore.send(.onAppear) }

            if !.isPhone {
                WelcomeView()
            }
        }
        .phoneOnlyStackNavigationView()
    }

    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.richtext")
                .font(Font.system(.largeTitle))
                .accessibility(hidden: true)
            Text(L10n.Home.emptyStateCopy)
                .font(.system(.title))
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var addReportButton: some View {
        VStack {
            NavigationLink(
                destination: ReportForm(
                    store: store.scope(
                        state: \.reportDraft,
                        action: HomeAction.report
                    )
                ),
                isActive: viewStore.binding(
                    get: \.showReportWizard,
                    send: HomeAction.showReportWizard
                ),
                label: {
                    EmptyView()
                }
            )
            Button(
                action: { viewStore.send(.showReportWizard(true)) },
                label: { Text("+")
                    .font(.largeTitle)
                }
            )

            .buttonStyle(AddReportButtonStyle())
            .accessibility(label: Text(L10n.Home.A11y.addReportButtonLabel))
        }
    }

    private var contactData: some View {
        NavigationLink(
            destination: SettingsView(
                store: store.scope(
                    state: \.settings,
                    action: HomeAction.settings
                )
            ),
            label: {
                Image(systemName: "gearshape")
                    .font(Font.system(.title2).bold())
            }
        )
        .accessibility(label: Text(L10n.Settings.title))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Preview {
            HomeView(
                store: .init(
                    initialState: HomeState(
                        reports: [.preview, .preview, .preview, .preview]
//                        reports: []
                    ),
                    reducer: .empty,
                    environment: ()
                )
            )
        }
    }
}

private extension Bool {
    static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}

private extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if .isPhone {
            navigationViewStyle(StackNavigationViewStyle())
        } else {
            self
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        Text("Welcome to weg-li")
            .font(.largeTitle)
        Text("📸 📝 ✊")
            .font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
    }
}
