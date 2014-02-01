(*
 * Copyright (c) 2010-2013 Anil Madhavapeddy <anil@recoil.org>
 * Copyright (c) 2013 Vincent Bernardoff <vb@luminar.eu.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

(** Module for dealing with TUN/TAP devices. TUN refers to layer 3
    virtual interfaces whereas TAP refers to layer 2 ones. *)

val opentun : ?pi:bool -> ?persist:bool -> ?user:int
  -> ?group:int -> ?devname:string -> unit -> Unix.file_descr * string
(** [opentun ~pi ~persist ~user ~group ~devname ()] will create a TUN
    interface. If [devname] is specified, or if [devname] specify an
    unexistant device, a new device will be created, otherwise, the
    interface [devname] will be opened. [no_pi] is to indicate if you
    want packet information associated with your frames (tap) or
    packets (tun) (defaults to no information). [persist] will set the
    device persistent with permissions set to [user] and [group] if
    supported by your OS (currently MacOSX does not support it). The
    return value is a pair consisting of a fd opened on the freshly
    created interface, and its name as will be displayed by command
    [ifconfig] for example. *)

val opentap : ?pi:bool -> ?persist:bool -> ?user:int
  -> ?group:int -> ?devname:string -> unit -> Unix.file_descr * string
(** Like [opentun], but open TAP interfaces instead of TUN ones. *)

val closetun : string -> unit
(** [closetun devname kind] will destroy [devname], if it exists. *)

val closetap : string -> unit
(** Like [closetun], but for TAP interfaces. *)

val get_ifnamsiz : unit -> int
(** [get_ifnamsiz ()] is the value of the constant IFNAMSIZ,
    defined in <net/if.h>. Useful for allocating buffers that contain
    interface names. *)

val get_macaddr : string -> Macaddr.t
(** [get_hwaddr devname] is the MAC address of interface
    [devname], as a raw string (not hexa). *)

val set_ipv4 : devname:string -> ipv4:string -> ?netmask:string -> unit -> unit
(** [set_ipv4 devname ipv4addr netmask] assign an IPv4 to interface
    [devname]. *)

val set_up_and_running : string -> unit
(** [set_up_and_running devname] sets interface [devname] up and
    running. Note that when using the [set_ipv4] function, the
    interface will automatically be set up and running. *)

type sa_family = V4 | V6 | Unix | Other

type ifaddr = {
  name: string;
  sa_family: sa_family;
  addr: Ipaddr.t option;
  mask: Ipaddr.t option;
  brd:  Ipaddr.t option;
}
(** Type of the interface addresses record. *)

val getifaddrs : unit -> ifaddr list
(** [getifaddrs ()] is the list of IP addresses of this host. *)
