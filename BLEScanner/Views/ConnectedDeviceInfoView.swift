//
//  ConnectedDeviceInfoView.swift
//  BLEScanner
//
//  Created by Anna Koulaeva on 19.02.2023.
//

import SwiftUI

struct ConnectedDeviceInfoView: View {
    private enum StringConstants {
        static let name = "Device name"
        static let description = "Device description"
        static let id = "Identifier"
        static let services = "Services"
        static let characteristicsProperties = "Characteristics Properties"
        static let disconnect = "Disconnect device"
    }
    
    @Binding var shouldDisconnectCurrentDevice: Bool
    @Binding var deviceInfo: DeviceInfo?
    @State var shouldShowServices = false
    
    var body: some View {
        VStack {
            Group {
                if let deviceInfo = deviceInfo {
                    infoField(fieldName: StringConstants.name, data: deviceInfo.peripheralData.name)
                    infoField(fieldName: StringConstants.description, data: deviceInfo.peripheralData.description)
                    infoField(fieldName: StringConstants.id, data: deviceInfo.peripheralData.identifier)
                }
                
                Divider()
            }
                .padding(.vertical, UIConstants.Padding.small)
                .padding(.horizontal, UIConstants.Padding.large)
            
            showServicesButton
                .padding(.vertical, UIConstants.Padding.small)
            
            if shouldShowServices {
                servicesListView
                    .animation(.linear(duration: 5), value: shouldShowServices)
            }
            
            Spacer()
            
            disconnectDeviceButton
                .padding(.vertical, UIConstants.Padding.small)
        }
            .navigationBarBackButtonHidden(true)
    }
    
    //MARK: -Additional views
    private var showServicesButton: some View {
        Button {
            shouldShowServices.toggle()
        } label: {
            HStack {
                Text(StringConstants.services)
                    .bold()
                Image(systemName: shouldShowServices ? "chevron.up.circle" : "chevron.down.circle")
            }
                .padding(.all, UIConstants.Padding.small)
                .background(
                    RoundedRectangle(cornerRadius: UIConstants.CornerRadius.small)
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                )
                .foregroundColor(.gray)
        }
    }
    
    private var servicesListView: some View {
        VStack {
            if let deviceInfo = deviceInfo {
                List(deviceInfo.services) { service in
                    Section("\(service.name + " " + StringConstants.characteristicsProperties)") {
                        ForEach(service.characteristicsProperties) { property in
                            Text(property)
                        }
                    }
                }
            }
        }
    }
    
    private var disconnectDeviceButton: some View {
        Button {
            shouldDisconnectCurrentDevice.toggle()
        } label: {
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.normal)
                .foregroundColor(UIConstants.mainColor)
                .overlay(
                    Text(StringConstants.disconnect)
                        .foregroundColor(.white)
                        .font(.title)
                        .minimumScaleFactor(0.85)
                        .padding(.horizontal, UIConstants.Padding.small)
                )
                .frame(height: UIConstants.screenHeight * 0.1)
                .padding(.horizontal, UIConstants.Padding.xlarge)
        }
    }
    
    //MARK: -Additional views functions
    private func infoField(fieldName: String, data: String) -> some View {
        HStack(alignment: .top) {
            Text("\(fieldName + ":")")
                .bold()
                .frame(width: UIConstants.screenWidth * 0.3, alignment: .leading)
                .padding(.trailing, UIConstants.Padding.small)
            
            Text(data)
            
            Spacer()
        }
    }
}

struct ConnectedDeviceInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectedDeviceInfoView(shouldDisconnectCurrentDevice: .constant(false),
                                deviceInfo: .constant(.init(peripheralData: .init(name: "Super cool device",
                                                                        description: "Yep, this device is definitely super cool",
                                                                        identifier: "131313"),
                                                  services: [.init(name: "First Service",
                                                                   characteristicsProperties: ["Read"]),
                                                             .init(name: "Second service", characteristicsProperties: ["Read", "Write"]),
                                                             .init(name: "Third service", characteristicsProperties: ["Read", "Write", "Unknown"])])))
    }
}
