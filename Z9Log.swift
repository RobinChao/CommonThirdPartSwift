   
   // Just  for  Swift  Lan
   // 打印日志工具，支持打印当前文件名、当前方法名、当前行、信息
   
  /*
  符号                            类型                              描述
  FILE                              String              包含这个符号的文件的路径
  LINE                              Int                     符号出现处的行号
  COLUMN                    Int                     符号出现处的列
  FUNCTION              String                  包含这个符号的方法名字
  */
  
  func Log<T>(message: T,
                                        file: String = __FILE__,
                              method: String = __FUNCTION__,
                                      line: Int = __LINE__)  {
            #if DEBUG
                print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
            #endif
  }