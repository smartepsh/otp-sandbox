defmodule ModuleUpgrade do
  @moduledoc """
  # 测试模块热更新规则

  1.虚拟机内针对同一模块，同一时刻，仅有两个版本代码，current 和 old；
  2.正在运行中的代码，若使用 MODULE.function() 形式调用，则会自动切换到新代码；
  3.若仅使用 function() 方式调用，则仍旧保持旧代码；
  4.当第 3 个版本加载后，运行在第一个版本上并以 function() 方式调用的进程，会自动停止
  """
  def start do
    # don't auto switch to new code
    Task.start(fn -> loop_1("first") end)

    # auto switch to new code
    Task.start(fn -> loop_2("second") end)
  end

  defp loop_1(content, interval \\ 1000) do
    Process.sleep(interval)
    IO.inspect(content)
    loop_1(content)
  end

  # must be public method because of __MODULE__.loop_2()
  def loop_2(content, interval \\ 1000) do
    Process.sleep(interval)
    IO.inspect("-------------------")
    IO.inspect(content)
    __MODULE__.loop_2(content)
  end
end
