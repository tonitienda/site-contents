import { makeScene2D, Rect, Line, Txt, Circle } from "@motion-canvas/2d"
import {
  createRef,
  all,
  waitFor,
  tween,
  easeInOutCubic,
} from "@motion-canvas/core"
import { Browser, Server, VM } from "../../components"

export default makeScene2D(function* (view) {
  // References

  const browser = createRef<Browser>()
  const vm = createRef<VM>()
  const nginx = createRef<Server>()
  // Layout
  view.add(
    <>
      <Browser
        ref={browser}
        x={-400}
        y={0}
        width={350}
        height={250}
        title="Client"
        url="http://localhost/status"
        titleBarColor="#2d71eeff"
      />

      <VM
        ref={vm}
        x={350}
        y={0}
        width={450}
        height={300}
        vmName="VPS"
        status="running"
        cpuUsage={0.2}
        memoryUsage={0.4}
      />
    </>
  )
  vm().addComponent(
    <Server
      ref={nginx}
      label="NGINX"
      serverType="nginx"
      status="active"
      width={150}
      height={100}
      y={-60}
    />,
    -100,
    -60
  )

  vm().addComponent(
    <Server
      ref={nginx}
      label="SERVER"
      serverType="app"
      status="active"
      width={150}
      height={100}
      y={-60}
    />,
    100,
    -60
  )
  //   yield* browser().open(0.3)
  //   yield* waitFor(0.2)
})
